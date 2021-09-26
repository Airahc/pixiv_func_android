/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:illust_content_page.dart
 * 创建时间:2021/8/25 下午7:41
 * 作者:小草
 */
import 'package:extended_image/extended_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pixiv_func_android/api/entity/illust.dart';
import 'package:pixiv_func_android/api/entity/tag.dart';
import 'package:pixiv_func_android/api/enums.dart';
import 'package:pixiv_func_android/downloader/downloader.dart';
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/model/search_filter.dart';
import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/provider/view_state.dart';
import 'package:pixiv_func_android/ui/page/illust/illust_comment/illust_comment_page.dart';
import 'package:pixiv_func_android/ui/page/image_scale/image_scale_page.dart';
import 'package:pixiv_func_android/ui/page/search/search_illust_result/search_illust_result_page.dart';
import 'package:pixiv_func_android/ui/page/user/user_page.dart';
import 'package:pixiv_func_android/ui/widget/avatar_view_from_url.dart';
import 'package:pixiv_func_android/ui/widget/html_rich_text.dart';
import 'package:pixiv_func_android/ui/widget/illust_previewer.dart';
import 'package:pixiv_func_android/ui/widget/image_view_from_url.dart';
import 'package:pixiv_func_android/util/page_utils.dart';
import 'package:pixiv_func_android/util/utils.dart';
import 'package:pixiv_func_android/view_model/illust_content_model.dart';
import 'package:pixiv_func_android/view_model/illust_previewer_model.dart';

class IllustContentPage extends StatefulWidget {
  final Illust illust;
  final IllustPreviewerModel? parentModel;

  const IllustContentPage(this.illust, {Key? key, this.parentModel}) : super(key: key);

  @override
  _IllustContentPageState createState() => _IllustContentPageState();
}

class _IllustContentPageState extends State<IllustContentPage> {
  Widget _buildBookmarkButton(IllustContentModel model) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).hintColor,
      child: model.bookmarkRequestWaiting
          ? CircularProgressIndicator()
          : model.isBookmarked
              ? Icon(
                  Icons.favorite_sharp,
                  size: 30,
                  color: Colors.pinkAccent,
                )
              : Icon(
                  Icons.favorite_outline_sharp,
                  size: 30,
                ),
      onPressed: () => model.bookmarkRequestWaiting ? null : model.changeBookmarkState(),
    );
  }

  Widget _buildImageItem(
    int illustId,
    String title,
    String previewUrl,
    String originUrl, {
    required Illust illust,
  }) {
    return Card(
      child: GestureDetector(
        onTap: () => PageUtils.to(
          context,
          ImageScalePage(
            illust: illust,
            initialPage: illust.pageCount > 1
                ? illust.metaPages.indexWhere((metaPage) => metaPage.imageUrls.original == originUrl)
                : 0,
          ),
        ),
        onLongPress: () => Downloader.start(illust: widget.illust, url: originUrl),
        child: ImageViewFromUrl(previewUrl),
      ),
    );
  }

  Widget _buildUgoira(IllustContentModel model) {
    if (null == model.gifBytes) {
      return SliverToBoxAdapter(
        child: GestureDetector(
          onTap: !model.generatingGif ? model.startGenerateGif : null,
          child: Hero(
            tag: 'illust:${model.illust.id}',
            child: Container(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ImageViewFromUrl(Utils.getPreviewUrl(model.illust)),
                  model.downloadingGif
                      ? CircularProgressIndicator()
                      : model.generatingGif
                          ? CircularProgressIndicator()
                          : Icon(Icons.play_circle_outline_outlined, size: 70),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return SliverToBoxAdapter(
        child: GestureDetector(
          onLongPress: model.saveGifFile,
          child: Hero(
            tag: 'illust:${model.illust.id}',
            child: Container(
              child: ExtendedImage.memory(model.gifBytes!),
            ),
          ),
        ),
      );
    }
  }

  Widget _buildImages(Illust illust) {
    final previewUrl = Utils.getPreviewUrl(illust);
    if (1 == illust.pageCount) {
      return SliverToBoxAdapter(
        child: Hero(
          tag: 'illust:${illust.id}',
          child: _buildImageItem(
            illust.id,
            illust.title,
            previewUrl,
            illust.metaSinglePage.originalImageUrl!,
            illust: illust,
          ),
        ),
      );
    } else {
      bool first = true;
      return SliverList(
        delegate: SliverChildListDelegate(
          illust.metaPages.map(
            (matePage) {
              if (first) {
                first = false;
                return Hero(
                  tag: 'illust:${illust.id}',
                  child: _buildImageItem(
                    illust.id,
                    illust.title,
                    previewUrl,
                    matePage.imageUrls.original!,
                    illust: illust,
                  ),
                );
              } else {
                return _buildImageItem(
                  illust.id,
                  illust.title,
                  previewUrl,
                  matePage.imageUrls.original!,
                  illust: illust,
                );
              }
            },
          ).toList(),
        ),
      );
    }
  }

  //如果这样写 null != tag.translatedName ? [...] : [...]
  //然后按Ctrl + S 热重载会失效(提示: "Reload not performed Analysis issues found")
  //所以我把他单独拿出来了
  ///[issue](https://github.com/flutter/flutter/issues/89043)
  Widget _buildTagWrap(List<Tag> tags) {
    return Wrap(
      alignment: WrapAlignment.start,
      runSpacing: 5,
      spacing: 5,
      children: tags.map(
        (tag) {
          final List<InlineSpan> children;
          if (null != tag.translatedName) {
            children = [
              TextSpan(
                text: '#${tag.name}  ',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              TextSpan(
                text: '${tag.translatedName}',
              ),
            ];
          } else {
            children = [
              TextSpan(
                text: '#${tag.name}',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              )
            ];
          }
          return RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyText2,
              children: children,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  PageUtils.to(
                    context,
                    SearchIllustResultPage(
                      word: tag.name,
                      filter: SearchFilter.create(
                        target: SearchTarget.EXACT_MATCH_FOR_TAGS,
                      ),
                    ),
                  );
                },
            ),
          );
        },
      ).toList(),
    );
  }

  Widget _buildDetail(IllustContentModel model) {
    final illust = model.illust;
    final children = <Widget>[];
    children.addAll([
      Container(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          //头像
          leading: GestureDetector(
            onTap: () => PageUtils.to(
              context,
              UserPage(
                illust.user.id,
                illustContentModel: model,
              ),
            ),
            child: Hero(
              tag: 'user:${illust.user.id}',
              child: AvatarViewFromUrl(illust.user.profileImageUrls.medium),
            ),
          ),
          //标题
          title: SelectableText(illust.title),
          //用户名
          subtitle: Text(illust.user.name),
        ),
      ),
      Container(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: InkWell(
          onLongPress: () async {
            await Utils.copyToClipboard('${illust.id}');
            platformAPI.toast('已将插画ID复制到剪切板');
          },
          child: Text('插画ID:${illust.id}'),
        ),
      ),

      //创建时间 & 查看数量 & 收藏数量
      Container(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Row(
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 12,
                ),
                children: [
                  TextSpan(text: Utils.japanDateToLocalDateString(DateTime.parse(illust.createDate))),
                  TextSpan(text: '  '),
                  TextSpan(
                    text: '${illust.totalView} ',
                    style: TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  TextSpan(text: '查看'),
                  TextSpan(text: '  '),
                  TextSpan(
                    text: '${illust.totalBookmarks} ',
                    style: TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  TextSpan(text: '收藏'),
                ],
              ),
            ),
          ],
        ),
      ),
      Container(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        alignment: Alignment.centerLeft,
        child: _buildTagWrap(illust.tags),
      ),
    ]);

    if (illust.caption.isNotEmpty) {
      children.add(
        Container(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: InkWell(
            onLongPress: () => model.showOriginalCaption = !model.showOriginalCaption,
            child: Card(
              child: Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.all(10),
                child: HtmlRichText(
                  illust.caption,
                  showOriginal: model.showOriginalCaption,
                ),
              ),
            ),
          ),
        ),
      );
    }

    children.add(
      Container(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Card(
          child: ListTile(
            onTap: () => PageUtils.to(context, IllustCommentPage(illust.id)),
            title: Center(
              child: Text('查看评论'),
            ),
          ),
        ),
      ),
    );

    return SliverList(
      delegate: SliverChildListDelegate(children),
    );
  }

  List<Widget> _buildRelated(IllustContentModel model) {
    final list = <Widget>[];

    if (model.viewState == ViewState.InitFailed) {
      list.add(
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: ListTile(
              onTap: model.loadFirstData,
              title: Center(
                child: Text('点击重新加载'),
              ),
              subtitle: Center(
                child: Text('加载相关推荐失败'),
              ),
            ),
          ),
        ),
      );
      return list;
    }

    if (ViewState.Empty == model.viewState) {
      list.add(
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: Center(
              child: Text('没有任何数据'),
            ),
          ),
        ),
      );
      return list;
    }

    if (model.initialized) {
      list.add(
        SliverGrid.count(
          crossAxisCount: 3,
          children: model.list
              .map(
                (illust) => GestureDetector(
                  onTap: () => PageUtils.to(context, IllustContentPage(illust)),
                  child: IllustPreviewer(illust: illust, square: true),
                ),
              )
              .toList(),
        ),
      );
    }

    if (model.viewState == ViewState.LoadFailed) {
      list.add(
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.all(20),
            child: ListTile(
              onTap: model.loadNextData,
              title: Text('点击重新加载'),
              subtitle: Text('加载相关推荐失败'),
            ),
          ),
        ),
      );
    }
    if (model.viewState == ViewState.Idle && model.hasNext) {
      list.add(
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: Card(
              child: ListTile(
                onTap: model.loadNextData,
                title: Center(child: Text('点击加载更多')),
              ),
            ),
          ),
        ),
      );
    }

    if (model.viewState == ViewState.Busy) {
      list.add(
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 25, 0, 25),
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
      );
    }

    return list;
  }

  Widget _buildBody(IllustContentModel model) {
    return CustomScrollView(
      slivers: [
        model.isUgoira ? _buildUgoira(model) : _buildImages(model.illust),
        _buildDetail(model),
      ]..addAll(_buildRelated(model)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      model: IllustContentModel(widget.illust, illustPreviewerModel: widget.parentModel),
      builder: (BuildContext context, IllustContentModel model, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("插画详细"),
          ),
          floatingActionButton: _buildBookmarkButton(model),
          body: _buildBody(model),
        );
      },
      onModelReady: (IllustContentModel model) => model.loadFirstData(),
    );
  }
}
