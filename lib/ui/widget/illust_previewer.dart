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

  const IllustPreviewer({Key? key, required this.illust, this.illustContentModel}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      model: IllustPreviewerModel(illust, illustContentModel: illustContentModel),
      builder: (BuildContext context, IllustPreviewerModel model, Widget? child) {
        return Card(
          child: Container(
            padding: EdgeInsets.all(5),
            child: Column(
              children: [
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final previewHeight = constraints.maxWidth / model.illust.width * model.illust.height;
                    return ImageViewFromUrl(
                      model.illust.imageUrls.medium,
                      width: constraints.maxWidth,
                      height: previewHeight,
                      imageBuilder: (Widget imageWidget) {
                        return Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                PageUtils.to(
                                  context,
                                  IllustContentPage(
                                    model.illust,
                                    parentModel: model,
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
                              top: 2,
                              right: 2,
                              child: Card(
                                color: Colors.white12,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  child: Text(
                                    '${model.illust.pageCount}',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      model.illust.title,
                      style: TextStyle(fontSize: 14),
                    ),
                    subtitle: Text(
                      model.illust.user.name,
                      style: TextStyle(fontSize: 10),
                    ),
                    trailing: model.bookmarkRequestWaiting ? RefreshProgressIndicator() : _buildBookmarkButton(model),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
