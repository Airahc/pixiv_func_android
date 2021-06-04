/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : search_content_page.dart
 */

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pixiv_xiaocao_android/api/entity/search/illust.dart';
import 'package:pixiv_xiaocao_android/api/pixiv_request.dart';
import 'package:pixiv_xiaocao_android/component/image_view_from_url.dart';
import 'package:pixiv_xiaocao_android/pages/illust/illust_page.dart';
import 'package:pixiv_xiaocao_android/pages/search/search_settings.dart';
import 'package:pixiv_xiaocao_android/util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchContentPage extends StatefulWidget {
  final String searchKeyword;

  SearchContentPage(this.searchKeyword);

  @override
  _SearchContentPageState createState() => _SearchContentPageState();
}

class _SearchContentPageState extends State<SearchContentPage> {
  late String searchKeyword = widget.searchKeyword;

  final List<Illust> _illusts = <Illust>[];

  final ScrollController _scrollController = ScrollController();

  final RefreshController _refreshController =
  RefreshController(initialRefresh: true);

  int _currentPage = 1;

  int _total = 0;

  bool _hasNext = true;

  @override
  void initState() {
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

  Future _loadData(
      {void Function()? onSuccess, void Function()? onFail}) async {
    var isSuccess = false;

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
        _hasNext = searchData.body!.lastPage != ++_currentPage;
        _total = searchData.body!.total;
        searchData.body!.illusts.forEach((illust) {
          if (illust != null) {
            _illusts.add(illust);
          }
        });
        isSuccess = true;
      }
    }

    if (isSuccess) {
      onSuccess?.call();
    } else {
      onFail?.call();
    }
  }

  Widget _buildIllustsPreview() {
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
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return Container(
                      width: constraints.maxWidth,
                      height: constraints.maxWidth,
                      child: ImageViewFromUrl(
                        _illusts[index].urlS,
                        fit: BoxFit.cover,
                        imageBuilder: (Widget imageWidget) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Util.gotoPage(
                                    context,
                                    IllustPage(
                                      _illusts[index].id,
                                      onBookmarkAdd: (bookmarkId) {
                                        if (this.mounted) {
                                          setState(() {
                                            _illusts[index].bookmarkId =
                                                bookmarkId;
                                          });
                                        }
                                      },
                                      onBookmarkDelete: () {
                                        if (this.mounted) {
                                          setState(() {
                                            _illusts[index].bookmarkId = null;
                                          });
                                        }
                                      },
                                    ),
                                  );
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
                    trailing: Util.buildBookmarkButton(
                      context,
                      illustId: _illusts[index].id,
                      bookmarkId: _illusts[index].bookmarkId,
                      updateCallback: (int? bookmarkId) {
                        if (this.mounted) {
                          setState(() {
                            _illusts[index].bookmarkId = bookmarkId;
                          });
                        }
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
      component = SingleChildScrollView(
        controller: _scrollController,
        child: _buildIllustsPreview(),
      );
    } else {
      component = Container();
    }
    return component;
  }

  Future<void> _onRefresh() async {
    setState(() {
      _illusts.clear();
      _currentPage = 1;
      _hasNext = true;
    });

    await _loadData();
    if (_illusts.isEmpty) {
      _refreshController.loadNoData();
    } else {
      _refreshController.loadComplete();
    }

    if (this.mounted) {
      setState(() {});
    }
    _refreshController.refreshCompleted();
  }

  Future<void> _onLoading() async {
    await _loadData(onSuccess: () {
      if (this.mounted) {
        setState(() {
          if (_hasNext) {
            _refreshController.loadComplete();
          } else {
            _refreshController.loadNoData();
          }
        });
      }
    }, onFail: () {
      _refreshController.loadFailed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Builder(
        builder: (BuildContext context) {
          return FloatingActionButton(
            heroTag: '滚动到顶部',
            backgroundColor: Colors.black.withAlpha(200),
            child: Icon(
              Icons.arrow_upward_outlined,
              color: Colors.white,
            ),
            onPressed: _scrollToTop,
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
        actions: [
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                splashRadius: 20,
                icon: Icon(
                  Icons.settings,
                  color: Colors.white.withAlpha(220),
                ),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          )
        ],
        title: Text('${_illusts.length}/$_total条'),
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: MaterialClassicHeader(
          color: Colors.pinkAccent,
        ),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus? mode) {
            Widget body;
            switch (mode) {
              case LoadStatus.idle:
                body = Text("上拉,加载更多");
                break;
              case LoadStatus.canLoading:
                body = Text("松手,加载更多");
                break;
              case LoadStatus.loading:
                body = CircularProgressIndicator();
                break;
              case LoadStatus.noMore:
                body = Text("没有更多数据啦");
                break;
              case LoadStatus.failed:
                body = Text('加载失败');
                break;
              default:
                body = Container();
                break;
            }

            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: _buildBody(),
      ),
    );
  }
}
