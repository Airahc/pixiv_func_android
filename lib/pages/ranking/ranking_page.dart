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
import 'package:pixiv_xiaocao_android/utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RankingPage extends StatefulWidget {
  @override
  _RankingPageState createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  final List<Illust> _illusts = <Illust>[];

  int _currentPage = 1;

  final ScrollController _scrollController = ScrollController();

  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  bool _hasNext = true;

  bool _initialize = false;

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

  Future<void> _loadData(
      {void Function()? onSuccess, void Function()? onFail}) async {
    var isSuccess = false;

    final rankingData = await PixivRequest.instance.getRanking(
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
        onFail?.call();
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
        onFail?.call();
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
            requestException: (e) {
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
                    _illusts.addAll(worksData.body!.illustDetails);
                  } else {
                    _hasNext = false;
                  }
                  isSuccess = true;
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
                                    Utils.gotoPage(
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
                          style: TextStyle(fontSize: 10)),
                      trailing: Utils.buildBookmarkButton(
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
      if (this.mounted) {
        setState(() {
        if (!_initialize) {
          _initialize = true;
        }
        if (_hasNext) {
            _refreshController.loadComplete();
          } else {
            _refreshController.loadNoData();
          }
        });
      }
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
      body: SmartRefresher(
        scrollController: _scrollController,
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: _initialize,
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
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: _buildBody(),
      ),
    );
  }
}
