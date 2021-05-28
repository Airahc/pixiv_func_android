/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : search_by_image_page.dart
 */
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pixiv_xiaocao_android/api/entity/illust_many/illust.dart';
import 'package:pixiv_xiaocao_android/api/pixiv_request.dart';
import 'package:pixiv_xiaocao_android/component/image_view_from_url.dart';
import 'package:pixiv_xiaocao_android/log/log_entity.dart';
import 'package:pixiv_xiaocao_android/log/log_util.dart';
import 'package:pixiv_xiaocao_android/pages/illust/illust_page.dart';
import 'package:pixiv_xiaocao_android/util.dart';

class SearchByImagePage extends StatefulWidget {
  final List<int> ids;

  SearchByImagePage(this.ids);

  @override
  _SearchByImagePageState createState() => _SearchByImagePageState();
}

class _SearchByImagePageState extends State<SearchByImagePage> {
  List<Illust> _illusts = <Illust>[];

  ScrollController _scrollController = ScrollController();

  static const int _pageQuantity = 30;

  int _currentPage = 1;

  bool _hasNext = true;
  bool _loading = false;

  @override
  void initState() {
    _loadIllustsData(reload: false);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void scrollToTop() {
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

  Future _loadIllustsData({bool reload = true}) async {
    if (this.mounted) {
      setState(() {
        if (reload) {
          _illusts.clear();
          _currentPage = 1;
        }
        _loading = true;
      });
    } else {
      return;
    }
    final startOffset = (_currentPage - 1) * _pageQuantity;

    final endOffset = widget.ids.length >= startOffset + _pageQuantity
        ? startOffset + _pageQuantity
        : widget.ids.length;

    _hasNext = widget.ids.length >= startOffset + _pageQuantity;

    final illusts = await PixivRequest.instance.queryIllustsById(
      widget.ids.getRange(startOffset, endOffset).toList(),
      requestException: (e) {
        LogUtil.instance.add(
          type: LogType.NetworkException,
          id: 0,
          title: '查询作品信息失败',
          url: '',
          context: '在搜索图片页面',
          exception: e,
        );
      },
      decodeException: (e, response) {
        LogUtil.instance.add(
          type: LogType.DeserializationException,
          id: 0,
          title: '查询作品信息反序列化异常',
          url: '',
          context: response,
          exception: e,
        );
      },
    );
    if (this.mounted) {
      if (illusts != null) {
        if (!illusts.error) {
          if (illusts.body != null) {
            ++_currentPage;
            setState(() {
              _illusts.addAll(illusts.body!.illustDetails);
            });
          }
        } else {
          LogUtil.instance.add(
            type: LogType.Info,
            id: 0,
            title: '查询作品信息失败',
            url: '',
            context: 'error:${illusts.message}',
          );
        }
      }
    } else {
      return;
    }

    if (this.mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  Widget _buildIllustsPreview() {
    return StaggeredGridView.countBuilder(
      shrinkWrap: true,
      crossAxisCount: 2,
      itemCount: _illusts.length,
      staggeredTileBuilder: (index) => StaggeredTile.fit(1),
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
      final List<Widget> list = [];
      list.add(_buildIllustsPreview());

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
                _loadIllustsData();
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
      if (widget.ids.isNotEmpty) {
        if (_loading) {
          component = Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          component = ListView.builder(
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Center(
                  child: Text('加载数据失败'),
                ),
              );
            },
            physics: const AlwaysScrollableScrollPhysics(),
          );
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
          physics: const NeverScrollableScrollPhysics(),
        );
      }
    }
    return component;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('搜索图片'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadIllustsData,
        child: _buildBody(),
        backgroundColor: Colors.white,
      ),
    );
  }
}
