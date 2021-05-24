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

  List<int> _ids = <int>[];

  List<Illust> _illusts = <Illust>[];

  final _scrollController = ScrollController();

  static const int _pageQuantity = 30;

  int _currentPage = 1;

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

  Future _loadData({bool reload = true, bool init = false}) async {
    if (this.mounted) {
      setState(() {
        if (reload) {
          _ids.clear();
          _illusts.clear();
          _currentPage = 1;
          _hasNext = true;
        }
        if (init) {
          _initialize = false;
        }
        _loading = true;
      });
    } else {
      return;
    }

    final userAllWork = await PixivRequest.instance.getUserAllWork(
      widget.userId,
      requestException: (e) {
        LogUtil.instance.add(
          type: LogType.NetworkException,
          id: ConfigUtil.instance.config.userId,
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
            _hasNext = _ids.length > _pageQuantity;
            switch (widget.type) {
              case UserWorkType.illust:
                _ids.addAll(userAllWork.body!.illusts);
                break;
              case UserWorkType.manga:
                _ids.addAll(userAllWork.body!.manga);
                break;
            }
            await _loadIllustsData();
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

    if (this.mounted) {
      setState(() {
        if (init) {
          _initialize = true;
        }
        _loading = false;
      });
    }
  }

  Future _loadIllustsData() async {
    if (this.mounted) {
      setState(() {
        _loading = true;
      });
    } else {
      return;
    }
    final startOffset = (_currentPage - 1) * _pageQuantity;

    final endOffset = _ids.length >= startOffset + _pageQuantity
        ? startOffset + _pageQuantity
        : _ids.length;

    _hasNext = _ids.length >= startOffset + _pageQuantity;

    final works = await PixivRequest.instance.queryIllustsById(
      _ids.getRange(startOffset, endOffset).toList(),
      requestException: (e) {
        LogUtil.instance.add(
          type: LogType.NetworkException,
          id: ConfigUtil.instance.config.userId,
          title: '查询作品信息失败',
          url: '',
          context: '在用户页面',
          exception: e,
        );
      },
      decodeException: (e, response) {
        LogUtil.instance.add(
          type: LogType.DeserializationException,
          id: ConfigUtil.instance.config.userId,
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
            setState(() {
              _illusts.addAll(works.body!.illustDetails);
            });
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
    } else {
      return;
    }

    if (this.mounted) {
      setState(() {
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
                              context,
                              IllustPage(
                                _illusts[index].id,
                                onBookmarkAdd: (bookmarkId) {
                                  if (this.mounted) {
                                    setState(() {
                                      _illusts[index].bookmarkId = bookmarkId;
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
        physics: AlwaysScrollableScrollPhysics(),
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
    super.build(context);
    return RefreshIndicator(
      child: _buildBody(),
      onRefresh: _loadData,
      backgroundColor: Colors.white,
    );
  }
}
