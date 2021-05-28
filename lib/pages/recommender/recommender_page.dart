/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : recommender_page.dart
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pixiv_xiaocao_android/api/entity/illust_many/illust.dart';
import 'package:pixiv_xiaocao_android/api/pixiv_request.dart';
import 'package:pixiv_xiaocao_android/component/image_view_from_url.dart';
import 'package:pixiv_xiaocao_android/config/config_util.dart';
import 'package:pixiv_xiaocao_android/log/log_entity.dart';
import 'package:pixiv_xiaocao_android/log/log_util.dart';
import 'package:pixiv_xiaocao_android/pages/illust/illust_page.dart';
import 'package:pixiv_xiaocao_android/pages/left_drawer/left_drawer.dart';
import 'package:pixiv_xiaocao_android/util.dart';

class RecommenderPage extends StatefulWidget {
  @override
  _RecommenderPageState createState() => _RecommenderPageState();
}

class _RecommenderPageState extends State<RecommenderPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController = TabController(length: 3, vsync: this);

  int _currentIndex = 0;

  List<GlobalKey<_ContentState>> _globalKeys = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: LeftDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              splashRadius: 20,
              icon: Icon(
                Icons.menu,
                color: Colors.white.withAlpha(220),
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: TabBar(
          controller: _tabController,
          tabs: [
            Text('全部'),
            Text('全年龄'),
            Text('R-18'),
          ],
          onTap: (int index) {
            if (_currentIndex != index && _tabController.index == index) {
              _currentIndex = index;
            } else {
              _globalKeys[index].currentState?.scrollToTop();
            }
          },
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _Content(isR18: null, key: _globalKeys[0]),
          _Content(isR18: false, key: _globalKeys[1]),
          _Content(isR18: true, key: _globalKeys[2]),
        ],
      ),
    );
  }
}

class _Content extends StatefulWidget {
  final bool? isR18;

  _Content({required this.isR18, Key? key}) : super(key: key);

  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<_Content> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  ScrollController _scrollController = ScrollController();

  List<int> _ids = <int>[];

  List<Illust> _illusts = <Illust>[];

  bool _loading = false;

  bool _initialize = false;

  static const int _pageQuantity = 30;

  int _currentPage = 1;

  bool _hasNext = true;

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

    final recommender = await PixivRequest.instance.getRecommender(
      r18: widget.isR18,
      requestException: (e) {
        LogUtil.instance.add(
          type: LogType.NetworkException,
          id: ConfigUtil.instance.config.userId,
          title: '获取推荐作品失败',
          url: '',
          context: '在推荐作品页面',
          exception: e,
        );
      },
      decodeException: (e, response) {
        LogUtil.instance.add(
          type: LogType.DeserializationException,
          id: ConfigUtil.instance.config.userId,
          title: '获取推荐作品反序列化异常',
          url: '',
          context: response,
          exception: e,
        );
      },
    );

    if (this.mounted) {
      if (recommender != null) {
        if (!recommender.error) {
          if (recommender.body != null) {
            _hasNext = _ids.length > _pageQuantity;

            _ids.addAll(recommender.body!.recommendedWorkIds);

            await _loadIllustsData();
          }
        } else {
          LogUtil.instance.add(
            type: LogType.Info,
            id: ConfigUtil.instance.config.userId,
            title: '获取推荐作品失败',
            url: '',
            context: 'error:${recommender.message}',
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
          context: '在排行榜页面',
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
            id: ConfigUtil.instance.config.userId,
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
                LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                  return Container(
                    width: constraints.maxWidth,
                    height: constraints.maxWidth,
                    child: ImageViewFromUrl(
                      _illusts[index].urlS,
                      fit: BoxFit.fill,
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
                  );
                },),
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
    super.build(context);
    return RefreshIndicator(
      onRefresh: _loadData,
      child: _buildBody(),
      backgroundColor: Colors.white,
    );
  }
}
