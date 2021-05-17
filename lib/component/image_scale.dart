/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : image_scale.dart
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:pixiv_xiaocao_android/config.dart';

class ImageScale extends StatefulWidget {
  final List<String> urls;
  final int initialPage;

  ImageScale(this.urls, this.initialPage);

  @override
  _ImageScaleState createState() => _ImageScaleState();
}

class _ImageScaleState extends State<ImageScale> {
  late final _pageController = PageController(initialPage: widget.initialPage);
  late var _currentPage = widget.initialPage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('${_currentPage + 1}/${widget.urls.length}张'),
        ),
      ),
      body: ExtendedImageGesturePageView(
        controller: _pageController,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        children: widget.urls.map((url) {
          final imageUrl = Config.enableImageProxy
              ? url.replaceFirst("i.pximg.net", "i.pixiv.cat")
              : url;
          return ExtendedImage(
            image: CachedNetworkImageProvider(
              imageUrl,
              headers: {'Referer': Config.referer},
            ),
            mode: ExtendedImageMode.gesture,
            loadStateChanged: (ExtendedImageState state) {
              if (state.extendedImageLoadState == LoadState.loading) {
                return Center(child: CircularProgressIndicator());
              }
            },
            initGestureConfigHandler: (state) {
              return GestureConfig(
                  minScale: 0.9,
                  maxScale: 6.0,
                  speed: 1.0,
                  initialScale: 0.95,
                  inPageView: true);
            },
          );
        }).toList(),
      ),
    );
  }
}
