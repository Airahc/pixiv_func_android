/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : user_works.dart
 */

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pixiv_xiaocao_android/api/entity/illust_many/illust.dart';
import 'package:pixiv_xiaocao_android/api/pixiv_request.dart';
import 'package:pixiv_xiaocao_android/component/image_view_from_url.dart';
import 'package:pixiv_xiaocao_android/config/config_util.dart';
import 'package:pixiv_xiaocao_android/log/log_entity.dart';
import 'package:pixiv_xiaocao_android/log/log_util.dart';
import 'package:pixiv_xiaocao_android/pages/illust/illust_page.dart';
import 'package:pixiv_xiaocao_android/util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

enum UserWorkType { illust, manga }

class UserWorksContent extends StatefulWidget {
  final UserWorkType type;
  final int userId;

  UserWorksContent({required this.type, required this.userId, Key? key})
      : super(key: key);

  @override
  UserWorksContentState createState() => UserWorksContentState();
}

class UserWorksContentState extends State<UserWorksContent>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final List<int> _ids = <int>[];

  final List<Illust> _illusts = <Illust>[];

  final ScrollController _scrollController = ScrollController();

  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  static const int _pageQuantity = 30;

  int _currentPage = 1;

  bool _hasNext = true;

  bool _initialize = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _refreshController.dispose();
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

  Future _loadData({void Function()? onFail}) async {
    var isSuccess = false;

    final userAllWork = await PixivRequest.instance.getUserAllWork(
      widget.userId,
      requestException: (e) {
        LogUtil.instance.add(
          type: LogType.NetworkException,
          id: ConfigUtil.instance.config.currentAccount.userId,
          title: '获取用户作品失败',
          url: '',
          context: '在用户页面',
          exception: e,
        );
      },
      decodeException: (e, response) {
        LogUtil.instance.add(
          type: LogType.DeserializationException,
          id: widget.userId,
          title: '获取用户作品反序列化异常',
          url: '',
          context: response,
          exception: e,
        );
      },
    );

    if (this.mounted) {
      if (userAllWork != null) {
        if (!userAllWork.error) {
          if (userAllWork.body != null) {
            isSuccess = true;
            _hasNext = _ids.length > _pageQuantity;
            switch (widget.type) {
              case UserWorkType.illust:
                _ids.addAll(userAllWork.body!.illusts);
                break;
              case UserWorkType.manga:
                _ids.addAll(userAllWork.body!.manga);
                break;
            }
            if (_ids.isNotEmpty) {
              await _loadIllustsData();
            }
          }
        } else {
          LogUtil.instance.add(
            type: LogType.Info,
            id: widget.userId,
            title: '获取用户作品失败',
            url: '',
            context: 'error:${userAllWork.message}',
          );
        }
      }
    } else {
      return;
    }

    if (!isSuccess) {
      onFail?.call();
    }
  }

  Future _loadIllustsData(
      {void Function()? onSuccess, void Function()? onFail}) async {
    var isSuccess = false;

    final startOffset = (_currentPage - 1) * _pageQuantity;

    final endOffset = _ids.length > startOffset + _pageQuantity
        ? startOffset + _pageQuantity
        : _ids.length;

    _hasNext = _ids.length > startOffset + _pageQuantity;

    final works = await PixivRequest.instance.queryIllustsById(
      _ids.getRange(startOffset, endOffset).toList(),
      requestException: (e) {
        LogUtil.instance.add(
          type: LogType.NetworkException,
          id: ConfigUtil.instance.config.currentAccount.userId,
          title: '查询作品信息失败',
          url: '',
          context: '在用户页面',
          exception: e,
        );
      },
      decodeException: (e, response) {
        LogUtil.instance.add(
          type: LogType.DeserializationException,
          id: ConfigUtil.instance.config.currentAccount.userId,
          title: '查询作品信息反序列化异常',
          url: '',
          context: response,
          exception: e,
        );
      },
    );
    if (this.mounted) {
      if (works != null) {
        if (!works.error) {
          if (works.body != null) {
            ++_currentPage;

            _illusts.addAll(works.body!.illustDetails);
            isSuccess = true;
          }
        } else {
          LogUtil.instance.add(
            type: LogType.Info,
            id: widget.userId,
            title: '查询作品信息失败',
            url: '',
            context: 'error:${works.message}',
          );
        }
      }
    }

    if (isSuccess) {
      onSuccess?.call();
    } else {
      onFail?.call();
    }
  }

  Widget _buildIllustsPreview() {
    return Container(
      child: StaggeredGridView.countBuilder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        itemCount: _illusts.length,
        staggeredTileBuilder: (index) => StaggeredTile.fit(1),
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: Container(
              padding: EdgeInsets.all(5),
              child: Column(
                children: [
                  LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
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
                          Util.dateTimeToString(
                            DateTime.fromMillisecondsSinceEpoch(
                              _illusts[index].uploadTimestamp * 1000,
                            ),
                          ),
                          style: TextStyle(fontSize: 10)),
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
      ),
    );
  }

  Widget _buildBody() {
    late Widget component;
    if (_illusts.isNotEmpty) {
      component = _buildIllustsPreview();
    } else {
      component = Container();
    }

    return component;
  }

  Future<void> _onRefresh() async {
    setState(() {
      _ids.clear();
      _illusts.clear();
      _currentPage = 1;
      _hasNext = true;

      if (_initialize) {
        _initialize = false;
      }
    });

    await _loadData();
    if (_illusts.isEmpty) {
      _refreshController.loadNoData();
    } else {
        setState(() {
          if (_hasNext) {
            if (!_initialize) {
              _initialize = true;
            }
            _refreshController.loadComplete();
          } else {
            _refreshController.loadNoData();
          }
        });
    }


    _refreshController.refreshCompleted();

  }

  Future<void> _onLoading() async {
    await _loadIllustsData(onSuccess: () {
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
    super.build(context);
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: _initialize,
      header: MaterialClassicHeader(
        color: Colors.pinkAccent,
      ),
      footer: _initialize
          ? CustomFooter(
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
            )
          : null,
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: _buildBody(),
    );
  }
}
