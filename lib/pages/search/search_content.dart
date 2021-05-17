/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : search_content.dart
 */

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pixiv_xiaocao_android/api/entity/search/illust.dart';
import 'package:pixiv_xiaocao_android/api/pixiv_request.dart';
import 'package:pixiv_xiaocao_android/component/image_view_from_url.dart';
import 'package:pixiv_xiaocao_android/pages/illust/illust.dart';
import 'package:pixiv_xiaocao_android/pages/search/search_settings.dart';
import 'package:pixiv_xiaocao_android/util.dart';

class SearchContentPage extends StatefulWidget {
  final String searchKeyword;

  SearchContentPage(this.searchKeyword);

  @override
  _SearchContentPageState createState() => _SearchContentPageState();
}

class _SearchContentPageState extends State<SearchContentPage> {
  late String searchKeyword = widget.searchKeyword;

  List<Illust> _illusts = <Illust>[];

  final _scrollController = ScrollController();

  int _currentPage = 1;

  int _total = 0;

  bool _hasNext = true;
  bool _loading = false;

  bool _initialize = false;

  @override
  void initState() {
    _loadData(reload: false, init: true);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      if (_scrollController.offset != 0) {
        _scrollController.animateTo(
          0,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInQuad,
        );
      }
    }
  }

  Future _loadData({bool reload = true, bool init = false}) async {
    if (this.mounted) {
      setState(() {
        if (reload) {
          _illusts.clear();
          _currentPage = 1;
          _total = 0;
        }
        if (init) {
          _initialize = false;
        }
        _loading = true;
      });
    } else {
      return;
    }

    final searchData = await PixivRequest.instance.search(
      searchKeyword,
      page: _currentPage,
      mode: SearchSettings.ageLimitSelected,
      type: SearchSettings.workTypeSelected,
      searchMode: SearchSettings.searchModeSelected,
      startDate: SearchSettings.dateLimitChecked
          ? SearchSettings.dateToString(SearchSettings.startDate)
          : '',
      endDate: SearchSettings.dateLimitChecked
          ? SearchSettings.dateToString(SearchSettings.endDate)
          : '',
    );

    if (this.mounted) {
      if (searchData != null && searchData.body != null) {
        setState(() {
          _hasNext = searchData.body!.lastPage != _currentPage;
          _total = searchData.body!.total;
          searchData.body!.illusts.forEach((illust) {
            if (illust != null) {
              _illusts.add(illust);
            }
          });
        });
      }
    } else {
      return;
    }

    if (this.mounted) {
      setState(() {
        if (init) {
          _initialize = true;
        }
        _loading = false;
      });
    }
  }

  Widget _buildWorksGridView() {
    return StaggeredGridView.countBuilder(
      shrinkWrap: true,
      crossAxisCount: 2,
      itemCount: _illusts.length,
      staggeredTileBuilder: (index) => StaggeredTile.fit(1),
      mainAxisSpacing: 6,
      crossAxisSpacing: 6,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: Container(
            padding: EdgeInsets.all(5),
            child: Column(
              children: [
                ImageViewFromUrl(
                  _illusts[index].urlS,
                  fit: BoxFit.cover,
                  imageBuilder: (Widget imageWidget) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Util.gotoPage(
                                context, IllustPage(_illusts[index].id));
                          },
                          child: imageWidget,
                        ),
                        Positioned(
                          left: 2,
                          top: 2,
                          child: _illusts[index].tags.contains('R-18')
                              ? Card(
                                  color: Colors.pinkAccent,
                                  child: Text('R-18'),
                                )
                              : Container(),
                        ),
                        Positioned(
                          top: 2,
                          right: 2,
                          child: Card(
                            color: Colors.white12,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: Text(
                                '${_illusts[index].pageCount}',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(0),
                    title: Text(
                      '${_illusts[index].title}',
                      style: TextStyle(fontSize: 14),
                    ),
                    subtitle: Text(
                      '${_illusts[index].authorDetails.userName}',
                      style: TextStyle(fontSize: 10),
                    ),
                    // leading: AvatarViewFromUrl,
                    trailing: IconButton(
                      splashRadius: 20,
                      icon: Icon(Icons.favorite_outline_sharp),
                      onPressed: () {
                        if (_illusts[index].bookmarkId != null) {
                          PixivRequest.instance
                              .bookmarkDelete(_illusts[index].bookmarkId!)
                              .then((success) {
                            if (success) {
                              if (this.mounted) {
                                setState(() {
                                  _illusts[index].bookmarkId = null;
                                });
                              }
                              // print('删除成功');
                            } else {
                              // print('删除失败');
                            }
                          });
                        } else {}
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    late Widget component;
    if (_illusts.isNotEmpty) {
      final List<Widget> list = [];
      list.add(_buildWorksGridView());

      if (_loading) {
        list.add(SizedBox(height: 20));
        list.add(Center(
          child: CircularProgressIndicator(),
        ));
        list.add(SizedBox(height: 20));
      } else {
        if (_hasNext) {
          list.add(Card(
            child: ListTile(
              title: Text('加载更多'),
              onTap: () {
                _currentPage++;
                _loadData(reload: false);
              },
            ),
          ));
        } else {
          list.add(Card(child: ListTile(title: Text('没有更多数据啦'))));
        }
      }

      component = SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: list,
        ),
      );
    } else {
      if (_loading) {
        if (!_initialize) {
          component = Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          component = Container();
        }
      } else {
        component = ListView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Center(
                child: Text('没有任何数据'),
              ),
            );
          },
          physics: const AlwaysScrollableScrollPhysics(),
        );
      }
    }
    return component;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Builder(
        builder: (BuildContext context) {
          return FloatingActionButton(
            backgroundColor: Colors.black.withAlpha(200),
            child: Icon(
              Icons.settings,
              color: Colors.white.withAlpha(220),
            ),
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
          );
        },
      ),
      endDrawer: SearchSettings(),
      appBar: AppBar(
        leading: IconButton(
          tooltip: '返回',
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Tooltip(
          message: '滚动到顶部',
          child: InkWell(
            child: Text('${_illusts.length}/$_total条'),
            onTap: _scrollToTop,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: _buildBody(),
        backgroundColor: Colors.white,
      ),
    );
  }
}
