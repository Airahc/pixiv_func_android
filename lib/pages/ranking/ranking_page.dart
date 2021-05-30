/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : ranking_page.dart
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
import 'package:pixiv_xiaocao_android/pages/left_drawer/left_drawer.dart';
import 'package:pixiv_xiaocao_android/pages/ranking/ranking_settings.dart';
import 'package:pixiv_xiaocao_android/util.dart';

class RankingPage extends StatefulWidget {
  @override
  _RankingPageState createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  List<Illust> _illusts = <Illust>[];

  int _currentPage = 1;

  final _scrollController = ScrollController();

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
    setState(() {
      if (reload) {
        _illusts.clear();
        _currentPage = 1;
        _hasNext = true;
      }

      if (init) {
        _initialize = false;
      }
      _loading = true;
    });

    var rankingData = await PixivRequest.instance.getRanking(
      _currentPage,
      requestException: (e) {
        LogUtil.instance.add(
          type: LogType.NetworkException,
          id: ConfigUtil.instance.config.currentAccount.userId,
          title: '获取排行榜失败',
          url: '',
          context: '在排行榜页面',
          exception: e,
        );
      },
      decodeException: (e, response) {
        LogUtil.instance.add(
          type: LogType.DeserializationException,
          id: ConfigUtil.instance.config.currentAccount.userId,
          title: '获取排行榜反序列化异常',
          url: '',
          context: response,
          exception: e,
        );
      },
      mode: RankingSettings.isR18
          ? RankingSettings.modeR18Selected
          : RankingSettings.modeSelected,
      type: RankingSettings.typeSelected,
    );

    if (this.mounted) {
      if (rankingData != null) {
        if (!rankingData.error) {
          var worksData = await PixivRequest.instance.queryIllustsById(
            rankingData.body!.ranking.map((item) => item.illustId).toList(),
            requestException: (e){
              LogUtil.instance.add(
                type: LogType.NetworkException,
                id: ConfigUtil.instance.config.currentAccount.userId,
                title: '查询作品信息失败',
                url: '',
                context: '在排行榜页面',
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
            if (worksData != null) {
              if (!worksData.error) {
                if (worksData.body != null) {
                  if (worksData.body!.illustDetails.isNotEmpty) {
                    _hasNext = true;
                    ++_currentPage;
                    setState(() {
                      _illusts.addAll(worksData.body!.illustDetails);
                    });
                  } else {
                    _hasNext = false;
                  }
                }
              } else {
                LogUtil.instance.add(
                  type: LogType.Info,
                  id: ConfigUtil.instance.config.currentAccount.userId,
                  title: '获取作品信息失败',
                  url: '',
                  context: 'error:${worksData.message}',
                );
              }
            }
          } else {
            return;
          }
        } else {
          LogUtil.instance.add(
            type: LogType.Info,
            id: ConfigUtil.instance.config.currentAccount.userId,
            title: '获取排行榜失败',
            url: '',
            context: 'error:${rankingData.message}',
          );
        }
      }
    } else {
      return;
    }

    setState(() {
      if (init) {
        _initialize = true;
      }
      _loading = false;
    });
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
                    subtitle: Text('${_illusts[index].authorDetails.userName}',
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
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: list,
        ),
      );
    } else {
      if (_loading && !_initialize) {
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
        actions: [
          IconButton(
            splashRadius: 20,
            tooltip: '滚动到顶部',
            icon: Icon(Icons.arrow_upward_outlined),
            onPressed: _scrollToTop,
          ),
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
        title: Text('排行榜'),
      ),
      endDrawer: RankingSettings(),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: _buildBody(),
        backgroundColor: Colors.white,
      ),
    );
  }
}
