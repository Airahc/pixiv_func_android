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
import 'package:pixiv_xiaocao_android/api/entity/user_works/bookmark_data.dart';
import 'package:pixiv_xiaocao_android/api/entity/user_works/work.dart';
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

  List<Work> _works = <Work>[];

  final TextEditingController _pageViewQuantityController =
      TextEditingController(text: '100');

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
    _pageViewQuantityController.dispose();
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
          _works.clear();
        }
        if (init) {
          _initialize = false;
        }
        _loading = true;
      });
    } else {
      return;
    }

    var recommender = await PixivRequest.instance.getRecommender(
      int.parse(_pageViewQuantityController.text),
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
      if (recommender != null && recommender.recommendations.isNotEmpty) {

        var works = await PixivRequest.instance.queryWorksById(
          recommender.recommendations,
          false,
          requestException: (e) {
            LogUtil.instance.add(
              type: LogType.NetworkException,
              id: ConfigUtil.instance.config.userId,
              title: '查询作品失败',
              url: '',
              context: '在推荐作品页面',
              exception: e,
            );
          },
          decodeException: (e, response) {
            LogUtil.instance.add(
              type: LogType.DeserializationException,
              id: ConfigUtil.instance.config.userId,
              title: '查询作品反序列化异常',
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
                setState(() {
                  _works.addAll(works.body!.works.values);
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
      }
    } else {
      return;
    }

    if (this.mounted) {
      setState(() {
        _loading = false;
        if (init) {
          _initialize = true;
        }
      });
    }
  }

  Widget _buildWorksGridView() {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 2,
      controller: _scrollController,
      itemCount: _works.length,
      staggeredTileBuilder: (index) => StaggeredTile.fit(1),
      mainAxisSpacing: 6,
      crossAxisSpacing: 6,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: Container(
            padding: EdgeInsets.all(5),
            child: Column(
              children: [
                ImageViewFromUrl(
                  _works[index].url,
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
                                _works[index].id,
                                onBookmarkAdd: (bookmarkId) {
                                  if (this.mounted) {
                                    setState(() {
                                      _works[index].bookmarkData =
                                          BookmarkData(bookmarkId, false);
                                    });
                                  }
                                },
                                onBookmarkDelete: () {
                                  if (this.mounted) {
                                    setState(() {
                                      _works[index].bookmarkData = null;
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
                          child: _works[index].tags.contains('R-18')
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
                              child: Text('${_works[index].pageCount}'),
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
                      '${_works[index].title}',
                      style: TextStyle(fontSize: 14),
                    ),
                    subtitle: Text(
                      '${_works[index].userName}',
                      style: TextStyle(fontSize: 10),
                    ),
                    trailing: Util.buildBookmarkButton(
                      context,
                      illustId: _works[index].id,
                      bookmarkId: _works[index].bookmarkData?.id,
                      updateCallback: (int? bookmarkId) {
                        if (this.mounted) {
                          setState(() {
                            if (bookmarkId == null) {
                              _works[index].bookmarkData = null;
                            } else {
                              _works[index].bookmarkData =
                                  BookmarkData(bookmarkId, false);
                            }
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
    if (_works.isNotEmpty) {
      component = _buildWorksGridView();
    } else {
      if (_loading) {
        if (_initialize) {
          component = Container();
        } else {
          component = Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      } else {
        if (_initialize) {
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
        } else {
          component = Container();
        }
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
