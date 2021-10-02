/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:illust_previewer.dart
 * 创建时间:2021/8/27 下午4:49
 * 作者:小草
 */
import 'package:flutter/material.dart';
import 'package:pixiv_func_android/api/entity/illust.dart';
import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/ui/page/illust/illust_content_page.dart';
import 'package:pixiv_func_android/ui/widget/image_view_from_url.dart';
import 'package:pixiv_func_android/util/page_utils.dart';
import 'package:pixiv_func_android/util/utils.dart';
import 'package:pixiv_func_android/view_model/illust_content_model.dart';
import 'package:pixiv_func_android/view_model/illust_previewer_model.dart';

class IllustPreviewer extends StatelessWidget {
  final Illust illust;

  final IllustContentModel? illustContentModel;

  final bool square;

  final bool showUserName;

  final String? heroTag;

  const IllustPreviewer({
    Key? key,
    required this.illust,
    this.illustContentModel,
    this.square = false,
    this.showUserName = true,
    this.heroTag,
  }) : super(key: key);

  Widget _buildBookmarkButton(IllustPreviewerModel model) {
    return IconButton(
      splashRadius: 20,
      onPressed: model.bookmarkStateChange,
      icon: model.isBookmarked
          ? const Icon(
              Icons.favorite_sharp,
              color: Colors.pinkAccent,
            )
          : const Icon(
              Icons.favorite_outline_sharp,
            ),
    );
  }

  static final borderRadius = BorderRadius.circular(10);

  static const circularRadius = Radius.circular(10);

  Widget _buildImage({
    required String url,
    required double width,
    required double height,
    required BuildContext context,
    required IllustPreviewerModel model,
  }) {
    return ImageViewFromUrl(
      url,
      width: width,
      height: height,
      fit: square ? BoxFit.fill : BoxFit.fitWidth,
      imageBuilder: (Widget imageWidget) {
        return Stack(
          fit: StackFit.expand,
          children: [
            GestureDetector(
              onTap: () {
                PageUtils.to(
                  context,
                  IllustContentPage(
                    model.illust,
                    parentModel: square ? null : model,
                    heroTag: heroTag,
                  ),
                );
              },
              child: imageWidget,
            ),
            Visibility(
              visible: model.isR18,
              child: Positioned(
                left: 2,
                top: 2,
                child: Card(
                    color: Colors.pink.shade300,
                    child: const Padding(
                      padding: EdgeInsets.all(1.5),
                      child: Text('R-18'),
                    )),
              ),
            ),
            Visibility(
              visible: model.isUgoira,
              child: const Positioned(
                left: 2,
                bottom: 2,
                child: Card(
                  color: Colors.white12,
                  child: Padding(padding: EdgeInsets.fromLTRB(5, 0, 5, 0), child: Text('动图')),
                ),
              ),
            ),
            Visibility(
              visible: model.illust.pageCount > 1,
              child: Positioned(
                right: 2,
                top: 2,
                child: Card(
                  color: Colors.white12,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: Text('${model.illust.pageCount}'),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      model: IllustPreviewerModel(illust, illustContentModel: illustContentModel),
      builder: (BuildContext context, IllustPreviewerModel model, Widget? child) {
        if (square) {
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return _buildImage(
                url: model.illust.imageUrls.squareMedium,
                width: constraints.maxWidth,
                height: constraints.maxWidth,
                context: context,
                model: model,
              );
            },
          );
        } else {
          return Card(
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
            child: Column(
              children: [
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final previewHeight = constraints.maxWidth / model.illust.width * model.illust.height;

                    return Hero(
                      tag: null != heroTag ? heroTag! : 'illust:${model.illust.id}',
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(topLeft: circularRadius, topRight: circularRadius),
                        child: _buildImage(
                          url: Utils.getPreviewUrl(illust.imageUrls),
                          width: constraints.maxWidth,
                          height: previewHeight,
                          context: context,
                          model: model,
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  contentPadding: const EdgeInsets.only(left: 5),
                  title: Text(
                    model.illust.title,
                    style: const TextStyle(fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: showUserName
                      ? Text(
                          model.illust.user.name,
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        )
                      : null,
                  trailing:
                      model.bookmarkRequestWaiting ? const RefreshProgressIndicator() : _buildBookmarkButton(model),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
