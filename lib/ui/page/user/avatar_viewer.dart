/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:avatar_viewer.dart
 * 创建时间:2021/9/21 下午6:01
 * 作者:小草
 */
import 'package:flutter/material.dart';
import 'package:pixiv_func_android/downloader/downloader.dart';
import 'package:pixiv_func_android/ui/widget/image_view_from_url.dart';

class AvatarViewer extends StatelessWidget {
  final String url;

  const AvatarViewer({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 350,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ImageViewFromUrl(url),
            ),
            IconButton(
              tooltip: '保存原图',
              splashRadius: 20,
              onPressed: () => Downloader.start(url: url),
              icon: Icon(Icons.save_alt_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
