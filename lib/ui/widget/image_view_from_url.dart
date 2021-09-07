/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:image_view_from_url.dart
 * 创建时间:2021/8/25 下午8:42
 * 作者:小草
 */

import 'package:cached_network_image/cached_network_image.dart';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:pixiv_func_android/instance_setup.dart';

class ImageViewFromUrl extends StatelessWidget {
  static const _TARGET_HOST = 'i.pximg.net';

  final String url;

  final Color? color;

  final BlendMode? colorBlendMode;

  final double? width;

  final double? height;

  final BoxFit? fit;

  final Widget Function(Widget imageWidget)? imageBuilder;

  ImageViewFromUrl(
    this.url, {
    Key? key,
    this.color,
    this.colorBlendMode,
    this.width,
    this.height,
    this.fit,
    this.imageBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageUrl = url.replaceFirst(_TARGET_HOST, settingsManager.imageSource);

    return ExtendedImage(
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return Container(
              padding: EdgeInsets.all(5),
              child: Center(child: const CircularProgressIndicator()),
            );
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
        headers: {'Referer': 'https://app-api.pixiv.net/'},
      ),
      color: color,
      colorBlendMode: colorBlendMode,
      width: width,
      height: height,
      fit: fit,
    );
  }
}
