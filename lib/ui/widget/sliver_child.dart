/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:sliver_child.dart
 * 创建时间:2021/8/28 下午6:15
 * 作者:小草
 */
import 'package:flutter/material.dart';

class SliverChild extends StatelessWidget {
  final Widget child;

  const SliverChild(this.child, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) => child,
        childCount: 1,
      ),
    );
  }
}
