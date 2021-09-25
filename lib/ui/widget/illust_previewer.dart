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
import 'package:pixiv_func_android/view_model/illust_content_model.dart';
import 'package:pixiv_func_android/view_model/illust_previewer_model.dart';

class IllustPreviewer extends StatelessWidget {
  final Illust illust;

  final IllustContentModel? illustContentModel;

  final bool square;

  final bool showUserName;

  const IllustPreviewer({
    Key? key,
    required this.illust,
    this.illustContentModel,
    this.square = false,
    this.showUserName = true,
  }) : super(key: key);

  Widget _buildBookmarkButton(IllustPreviewerModel model) {
    return IconButton(
      splashRadius: 20,
      onPressed: model.bookmarkStateChange,
      icon: model.isBookmarked
          ? Icon(
              Icons.favorite_sharp,
              color: Colors.pinkAccent,
            )
          : Icon(
              Icons.favorite_outline_sharp,
            ),
    );
  }

  static final borderRadius = BorderRadius.circular(10);

  static final circularRadius = Radius.circular(10);

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
                  ),
                );
              },
              child: imageWidget,
            ),
            Positioned(
              left: 2,
              top: 2,
              child: model.illust.tags.any((tag) => tag.name == 'R-18')
                  ? Card(
                      color: Colors.pinkAccent,
                      child: Text('R-18'),
                    )
                  : Container(),
            ),
            Positioned(
              left: 2,
              bottom: 2,
              child: model.isUgoira
                  ? Card(
                      color: Colors.white12,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: Text('动图'),
                      ),
                    )
                  : Container(),
            ),
            Positioned(
              right: 2,
              top: 2,
              child: model.illust.pageCount > 1
                  ? Card(
                      color: Colors.white12,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: Text(
                          '${model.illust.pageCount}',
                        ),
                      ),
                    )
                  : Container(),
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
                    return ClipRRect(
                      borderRadius: BorderRadius.only(topLeft: circularRadius, topRight: circularRadius),
                      child: _buildImage(
                        url: model.illust.imageUrls.medium,
                        width: constraints.maxWidth,
                        height: previewHeight,
                        context: context,
                        model: model,
                      ),
                    );
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(left: 5),
                  title: Text(
                    model.illust.title,
                    style: TextStyle(fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: showUserName
                      ? Text(
                          model.illust.user.name,
                          style: TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        )
                      : null,
                  trailing: model.bookmarkRequestWaiting ? RefreshProgressIndicator() : _buildBookmarkButton(model),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
