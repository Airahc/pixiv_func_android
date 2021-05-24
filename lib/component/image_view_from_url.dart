/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : image_view_from_url.dart
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:pixiv_xiaocao_android/config/config_util.dart';

class ImageViewFromUrl extends StatelessWidget {
  final String url;

  final Color? color;

  final BlendMode? colorBlendMode;

  final double? width;

  final double? height;

  final BoxFit? fit;

  final Widget Function(Widget imageWidget)? imageBuilder;

  ImageViewFromUrl(
    this.url, {
    this.color,
    this.colorBlendMode,
    this.width,
    this.height,
    this.fit,
    this.imageBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = ConfigUtil.instance.config.enableImageProxy
        ? url.replaceFirst("i.pximg.net", "i.pixiv.cat")
        : url;

    return ExtendedImage(
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return const Center(child: const CircularProgressIndicator());
          case LoadState.completed:
            return imageBuilder?.call(state.completedWidget);
          case LoadState.failed:
            return Center(
              child: IconButton(
                icon: Icon(Icons.refresh_sharp),
                iconSize: 35,
                onPressed: () {
                  state.reLoadImage();
                },
              ),
            );
        }
      },
      image: CachedNetworkImageProvider(
        imageUrl,
        headers: {'Referer': ConfigUtil.referer},
      ),
      color: color,
      colorBlendMode: colorBlendMode,
      width: width,
      height: height,
      fit: fit,
    );
  }
}
