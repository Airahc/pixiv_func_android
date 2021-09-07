/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:avatar_view_from_url.dart
 * 创建时间:2021/8/27 下午8:42
 * 作者:小草
 */
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pixiv_func_android/instance_setup.dart';

class AvatarViewFromUrl extends StatelessWidget {
  static const _TARGET_HOST = 'i.pximg.net';

  final String url;
  final double? radius;

  const AvatarViewFromUrl(this.url, {Key? key, this.radius}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageUrl = url.replaceFirst(_TARGET_HOST, settingsManager.imageSource);

    return CircleAvatar(
      backgroundImage: CachedNetworkImageProvider(
        imageUrl,
        headers: {'Referer': 'https://app-api.pixiv.net/'},
      ),
      radius: radius,
    );
  }
}
