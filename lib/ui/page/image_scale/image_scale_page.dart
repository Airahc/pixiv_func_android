/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:image_scale_page.dart
 * 创建时间:2021/9/21 下午5:13
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:pixiv_func_android/api/entity/illust.dart';
import 'package:pixiv_func_android/downloader/downloader.dart';
import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/util/utils.dart';
import 'package:pixiv_func_android/view_model/image_scale_model.dart';
import 'package:extended_image/extended_image.dart';

class ImageScalePage extends StatelessWidget {
  final Illust illust;
  final int initialPage;

  const ImageScalePage({Key? key, required this.illust, this.initialPage = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final urls = <String>[];
    if (1 == illust.pageCount) {
      urls.add(illust.metaSinglePage.originalImageUrl!);
    } else {
      urls.addAll(illust.metaPages.map((metaPage) => metaPage.imageUrls.original!).toList());
    }

    return ProviderWidget(
      model: ImageScaleModel(urls: urls, initialPage: initialPage),
      builder: (BuildContext context, ImageScaleModel model, Widget? child) {
        final children = <Widget>[];
        for (int i = 0; i < urls.length; ++i) {
          children.add(
            Card(
              child: Column(
                children: [
                  Expanded(
                    child: ExtendedImage.network(
                      Utils.replaceImageSource(urls[i]),
                      headers: {'Referer': 'https://app-api.pixiv.net'},
                      gaplessPlayback: true,
                      mode: ExtendedImageMode.gesture,
                      loadStateChanged: (ExtendedImageState state) {
                        if (state.extendedImageLoadState == LoadState.loading) {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                      initGestureConfigHandler: (ExtendedImageState state) => GestureConfig(
                        minScale: 0.9,
                        maxScale: 6.0,
                        speed: 1.0,
                        initialScale: 0.95,
                        inPageView: true,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: '保存原图',
                    splashRadius: 20,
                    onPressed: () => Downloader.start(illust: illust, url: urls[i]),
                    icon: Icon(Icons.save_alt_outlined),
                  ),
                ],
              ),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('${model.currentPage + 1}/${model.urls.length}张'),
          ),
          body: ExtendedImageGesturePageView(
            controller: model.pageController,
            onPageChanged: (int page) => model.currentPage = page,
            children: children,
          ),
        );
      },
    );
  }
}
