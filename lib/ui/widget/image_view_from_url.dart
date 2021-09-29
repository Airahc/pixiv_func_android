/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:image_view_from_url.dart
 * 创建时间:2021/8/25 下午8:42
 * 作者:小草
 */

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:pixiv_func_android/util/utils.dart';

class ImageViewFromUrl extends StatelessWidget {
  final String url;

  final Color? color;

  final BlendMode? colorBlendMode;

  final double? width;

  final double? height;

  final BoxFit? fit;

  final Widget Function(Widget imageWidget)? imageBuilder;

  final Widget? placeholderWidget;

  const ImageViewFromUrl(
    this.url, {
    Key? key,
    this.color,
    this.colorBlendMode,
    this.width,
    this.height,
    this.fit,
    this.imageBuilder,
    this.placeholderWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filename = url.substring(url.lastIndexOf('/') + 1);
    return ExtendedImage.network(
      Utils.replaceImageSource(url),
      headers: const {'Referer': 'https://app-api.pixiv.net/'},
      //https://github.com/fluttercandies/extended_image/issues/355
      //https://github.com/fluttercandies/extended_image/issues/351
      //https://github.com/fluttercandies/extended_image/issues/402
      //当图像提供者改变时，是继续显示旧图像（真），还是暂时不显示（假）
      //防止刷新时图片闪烁 (降低extended_image版本到 3.0.0 这些问题都没有了)
      gaplessPlayback: true,
      cacheKey: filename,
      printError: false,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return placeholderWidget ??
                const Padding(
                  padding: EdgeInsets.all(5),
                  child: Center(child: CircularProgressIndicator()),
                );
          case LoadState.completed:
            return imageBuilder?.call(state.completedWidget);
          case LoadState.failed:
            return Center(
              child: IconButton(
                icon: const Icon(Icons.refresh_sharp),
                iconSize: 35,
                onPressed: state.reLoadImage,
              ),
            );
        }
      },
      color: color,
      colorBlendMode: colorBlendMode,
      width: width,
      height: height,
      fit: fit ?? BoxFit.fitWidth,
    );
  }
}
