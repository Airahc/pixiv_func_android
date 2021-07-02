/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : search_page.dart
 */

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pixiv_xiaocao_android/api/entity/search_suggestion/search_suggestion_body.dart';
import 'package:pixiv_xiaocao_android/api/entity/search_suggestion/tag_translation/tag_translation.dart';
import 'package:pixiv_xiaocao_android/api/entity/search_suggestion/thumbnail/thumbnail.dart';
import 'package:pixiv_xiaocao_android/api/pixiv_request.dart';
import 'package:pixiv_xiaocao_android/component/image_view_from_url.dart';
import 'package:pixiv_xiaocao_android/config/config_util.dart';
import 'package:pixiv_xiaocao_android/log/log_entity.dart';
import 'package:pixiv_xiaocao_android/log/log_util.dart';
import 'package:pixiv_xiaocao_android/pages/illust/illust_page.dart';
import 'package:pixiv_xiaocao_android/pages/left_drawer/left_drawer.dart';
import 'package:pixiv_xiaocao_android/pages/search/search_illust_result_page.dart';
import 'package:pixiv_xiaocao_android/pages/search/search_input.dart';
import 'package:pixiv_xiaocao_android/pages/search/search_settings.dart';
import 'package:pixiv_xiaocao_android/utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchSuggestionBody? _searchSuggestionData;

  final _scrollController = ScrollController();

  final RefreshController _refreshController =
  RefreshController(initialRefresh: true);


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

  Future _loadData({void Function()? onSuccess, void Function()? onFail}) async {
    var isSuccess = false;

    final searchSuggestion = await PixivRequest.instance.getSearchSuggestion(
      mode: 'all',
      requestException: (e) {
        LogUtil.instance.add(
          type: LogType.NetworkException,
          id: ConfigUtil.instance.config.currentAccount.userId,
          title: '获取搜索推荐失败',
          url: '',
          context: '在搜索页面',
          exception: e,
        );
      },
      decodeException: (e, response) {
        LogUtil.instance.add(
          type: LogType.DeserializationException,
          id: ConfigUtil.instance.config.currentAccount.userId,
          title: '获取搜索推荐反序列化异常',
          url: '',
          context: response,
          exception: e,
        );
      },
    );

    if (this.mounted) {
      if (searchSuggestion != null) {
        _searchSuggestionData = searchSuggestion.body;
        if (searchSuggestion.error) {
          LogUtil.instance.add(
            type: LogType.Info,
            id: ConfigUtil.instance.config.currentAccount.userId,
            title: '获取搜索推荐失败',
            url: '',
            context: '',
          );
        }else{
          isSuccess = true;
        }
      }
    }

    if (isSuccess) {
      onSuccess?.call();
    } else {
      onFail?.call();
    }
  }

  Thumbnail? _findThumbnail(int id) {
    Thumbnail? result;

    _searchSuggestionData?.thumbnails.forEach((thumbnail) {
      if (thumbnail.id == id) {
        result = thumbnail;
      }
    });
    return result;
  }

  TagTranslation? _findTagTranslation(String tag) {
    return _searchSuggestionData?.tagTranslation[tag];
  }

  Widget _recommendByTags() {
    var list = <Widget>[];

    _searchSuggestionData?.recommendByTags.illust.forEach((item) {
      var tagTranslation = _findTagTranslation(item.tag);

      String tag;
      if (tagTranslation?.zh != null && tagTranslation!.zh!.isNotEmpty) {
        tag = '#${tagTranslation.zh!}';
      } else if (tagTranslation?.en != null && tagTranslation!.en!.isNotEmpty) {
        tag = '#${tagTranslation.en!}';
      } else {
        tag = item.tag;
      }

      list.add(SizedBox(height: 10));
      list.add(Text(
        '$tag的推荐作品',
        style: TextStyle(fontSize: 22),
      ));
      list.add(SizedBox(height: 10));
      list.add(StaggeredGridView.countBuilder(
        shrinkWrap: true,
        crossAxisCount: 2,
        itemCount: item.ids.length,
        staggeredTileBuilder: (index) => StaggeredTile.fit(1),
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          final id = item.ids[index];
          final thumbnail = _findThumbnail(id);
          return Card(
            child: GestureDetector(
              onTap: () {
                Utils.gotoPage(
                  context,
                  IllustPage(id),
                );
              },
              child: Column(
                children: [
                  ImageViewFromUrl(thumbnail!.url),
                  SizedBox(height: 5),
                  Text('${thumbnail.title}'),
                  SizedBox(height: 5),
                ],
              ),
            ),
          );
        },
      ));
    });

    return Column(
      children: list,
    );
  }

  Widget _popularTags() {
    final list = <Widget>[];
    _searchSuggestionData?.popularTags.illust.forEach((illust) {
      final thumbnail = _findThumbnail(illust.ids.first);
      if (thumbnail != null)
        list.add(Card(
          child: Container(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Container(
                  width: constraints.maxWidth,
                  height: constraints.maxWidth,
                  child: ImageViewFromUrl(
                    thumbnail.url,
                    color: Colors.white54,
                    colorBlendMode: BlendMode.modulate,
                    imageBuilder: (Widget imageWidget) {
                      return Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          GestureDetector(
                            onTap: () {
                              SearchSettings.includeKeywords.clear();
                              SearchSettings.notIncludeKeywords.clear();
                              Utils.gotoPage(
                                  context, SearchIllustResultPage(illust.tag));
                            },
                            child: imageWidget,
                          ),
                          Text(illust.tag),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ));
    });
    return StaggeredGridView.countBuilder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      itemCount: list.length,
      staggeredTileBuilder: (index) => StaggeredTile.fit(1),
      itemBuilder: (BuildContext context, int index) {
        return list[index];
      },
    );
  }

  Widget _recommendTags() {
    final list = <Widget>[];
    _searchSuggestionData?.recommendTags.illust.forEach((illust) {
      final thumbnail = _findThumbnail(illust.ids.first);
      if (thumbnail != null)
        list.add(Card(
          child: Container(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Container(
                  width: constraints.maxWidth,
                  height: constraints.maxWidth,
                  child: ImageViewFromUrl(
                    thumbnail.url,
                    color: Colors.white54,
                    colorBlendMode: BlendMode.modulate,
                    imageBuilder: (Widget imageWidget) {
                      return Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          GestureDetector(
                            onTap: () {
                              SearchSettings.includeKeywords.clear();
                              SearchSettings.notIncludeKeywords.clear();
                              Utils.gotoPage(
                                  context, SearchIllustResultPage(illust.tag));
                            },
                            child: imageWidget,
                          ),
                          Text(illust.tag),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ));
    });
    return StaggeredGridView.countBuilder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      itemCount: list.length,
      staggeredTileBuilder: (index) => StaggeredTile.fit(1),
      itemBuilder: (BuildContext context, int index) {
        return list[index];
      },
    );
  }

  Widget _buildBody() {
    late Widget component;
    if (_searchSuggestionData != null) {
      component = ListView(
        controller: _scrollController,
        children: [
          SizedBox(height: 10),
          Text('推荐标签', style: TextStyle(fontSize: 25)),
          SizedBox(height: 10),
          _recommendTags(),
          SizedBox(height: 10),
          Text('热门标签', style: TextStyle(fontSize: 25)),
          _popularTags(),
          SizedBox(height: 10),
          _recommendByTags(),
        ],
      );
    } else {
      component = Container();
    }

    return component;
  }

  Future<void> _onRefresh() async {

    await _loadData();
    if (this.mounted) {
      setState(() {});
    }
    _refreshController.refreshCompleted();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: LeftDrawer(),
      appBar: AppBar(
        titleSpacing: 0,
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
        title: Text('搜索'),
      ),
      floatingActionButton: Builder(
        builder: (BuildContext context) {
          return FloatingActionButton(
            heroTag: '进入搜索输入页面',
            backgroundColor: Colors.black.withAlpha(200),
            child: Icon(
              Icons.search_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              Utils.gotoPage(context, SearchInputPage());
            },
          );
        },
      ),
      endDrawer: SearchSettings(),
      body: SmartRefresher(
        enablePullDown: true,
        header: MaterialClassicHeader(
          color: Colors.pinkAccent,
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: _buildBody(),
      ),
    );
  }
}
