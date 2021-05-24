/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : search_suggestion.dart
 */

import 'package:flutter/material.dart';
import 'package:pixiv_xiaocao_android/api/entity/search_suggestion/search_suggestion_body.dart';
import 'package:pixiv_xiaocao_android/api/entity/search_suggestion/tag_translation/tag_translation.dart';
import 'package:pixiv_xiaocao_android/api/entity/search_suggestion/thumbnail/thumbnail.dart';
import 'package:pixiv_xiaocao_android/api/pixiv_request.dart';
import 'package:pixiv_xiaocao_android/component/image_view_from_url.dart';
import 'package:pixiv_xiaocao_android/config/config_util.dart';
import 'package:pixiv_xiaocao_android/log/log_entity.dart';
import 'package:pixiv_xiaocao_android/log/log_util.dart';
import 'package:pixiv_xiaocao_android/pages/illust/illust_page.dart';
import 'package:pixiv_xiaocao_android/pages/search/search_content_page.dart';
import 'package:pixiv_xiaocao_android/pages/search/search_settings.dart';
import 'package:pixiv_xiaocao_android/util.dart';

class SearchSuggestionContent extends StatefulWidget {
  final String mode;

  SearchSuggestionContent(this.mode, {Key? key}) : super(key: key);

  @override
  SearchSuggestionContentState createState() => SearchSuggestionContentState();
}

class SearchSuggestionContentState extends State<SearchSuggestionContent>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  SearchSuggestionBody? _searchSuggestionData;

  final _scrollController = ScrollController();

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
          _searchSuggestionData = null;
        }
        if (init) {
          _initialize = false;
        }
        _loading = true;
      });
    } else {
      return;
    }

    final searchSuggestion = await PixivRequest.instance.getSearchSuggestion(
      mode: widget.mode,
      requestException: (e) {
        LogUtil.instance.add(
          type: LogType.NetworkException,
          id: ConfigUtil.instance.config.userId,
          title: '获取搜索推荐失败',
          url: '',
          context: '在搜索页面',
          exception: e,
        );
      },
      decodeException: (e, response) {
        LogUtil.instance.add(
          type: LogType.DeserializationException,
          id: ConfigUtil.instance.config.userId,
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
            id: ConfigUtil.instance.config.userId,
            title: '获取搜索推荐失败',
            url: '',
            context: '只是单纯的没成功',
          );
        }
      }
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

  Thumbnail? _findThumbnail(int id) {
    return _searchSuggestionData?.thumbnails
        .firstWhere((thumbnail) => thumbnail.id == id);
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
      var images = <Widget>[];
      item.ids.forEach((id) {
        var thumbnail = _findThumbnail(id);
        images.add(Card(
          child: GestureDetector(
            onTap: () {
              Util.gotoPage(
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
        ));
      });
      list.add(
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: images,
          ),
        ),
      );
    });

    return Column(
      children: list,
    );
  }

  Widget _popularTags() {
    var list = <Widget>[];

    _searchSuggestionData?.popularTags.illust.forEach((item) {
      list.add(Text('${item.tag}'));
      list.add(SizedBox(height: 10));
      var images = <Widget>[];
      item.ids.forEach((id) {
        var thumbnail = _findThumbnail(id);
        images.add(Card(
          child: ImageViewFromUrl(thumbnail!.url),
        ));
      });
      list.add(Row(
        children: images,
      ));
    });

    return Column(
      children: list,
    );
  }

  Widget _recommendTags() {
    var list = <Widget>[];

    _searchSuggestionData?.recommendTags.illust.forEach((item) {
      var thumbnail = _findThumbnail(item.ids.first);
      var tagTranslation = _findTagTranslation(item.tag);

      list.add(Card(
        child: GestureDetector(
          onTap: () {
            SearchSettings.includeKeywords.clear();
            SearchSettings.notIncludeKeywords.clear();
            Util.gotoPage(context, SearchContentPage(item.tag));
          },
          child: Container(
            padding: EdgeInsets.all(10),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ImageViewFromUrl(
                  thumbnail!.url,
                  color: Colors.white54,
                  colorBlendMode: BlendMode.modulate,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${tagTranslation?.en != null && tagTranslation!.en!.isNotEmpty ? '#${tagTranslation.en!}' : ''}',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      item.tag,
                      style: TextStyle(fontSize: 22),
                    ),
                    Text(
                      '${tagTranslation?.zh != null && tagTranslation!.zh!.isNotEmpty ? '#${tagTranslation.zh!}' : ''}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ));
    });

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(mainAxisSize: MainAxisSize.min, children: list),
    );
  }

  Widget _buildBody() {
    late Widget component;
    if (_searchSuggestionData != null) {
      component = SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 10),
              Text('推荐标签', style: TextStyle(fontSize: 25)),
              SizedBox(height: 10),
              _recommendTags(),
              SizedBox(height: 10),
              _recommendByTags(),
            ],
          ),
        ),
      );
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
