/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : avatar_view_from_url.dart
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pixiv_xiaocao_android/config/config_util.dart';

class AvatarViewFromUrl extends StatelessWidget {

  final String url;

  final double? radius;

  final double? minRadius;
  final double? maxRadius;

  final Widget Function(ImageProvider imageProvider)? imageBuilder;

  AvatarViewFromUrl(this.url,
      {this.radius, this.minRadius, this.maxRadius, this.imageBuilder});

  @override
  Widget build(BuildContext context) {
    final imageUrl = ConfigUtil.instance.config.enableImageProxy
        ? url.replaceFirst("i.pximg.net", "i.pixiv.cat")
        : url;
    return CircleAvatar(
      radius: radius,
      minRadius: minRadius,
      maxRadius: maxRadius,
      backgroundImage: CachedNetworkImageProvider(
        imageUrl,
        headers: {'Referer': ConfigUtil.referer},
      ),
    );
  }
}
