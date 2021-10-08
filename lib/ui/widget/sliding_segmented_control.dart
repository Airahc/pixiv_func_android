/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:sliding_segmented_control.dart
 * 创建时间:2021/10/8 下午8:49
 * 作者:小草
 */
import 'package:flutter/cupertino.dart';

class SlidingSegmentedControl<T extends Object> extends StatelessWidget {
  final Map<T, Widget> children;
  final ValueChanged<T?> onValueChanged;
  final T? groupValue;
  final bool splitEqually;

  const SlidingSegmentedControl({
    Key? key,
    required this.children,
    required this.groupValue,
    required this.onValueChanged,
    this.splitEqually = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (splitEqually) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SizedBox(
            width: constraints.maxWidth,
            child: CupertinoSlidingSegmentedControl(
              children: children.map(
                (key, value) => MapEntry(
                  key,
                  Container(
                    alignment: Alignment.center,
                    child: value,
                    width: constraints.maxWidth / children.length,
                  ),
                ),
              ),
              groupValue: groupValue,
              onValueChanged: onValueChanged,
            ),
          );
        },
      );
    } else {
      return CupertinoSegmentedControl(
        children: children,
        groupValue: groupValue,
        onValueChanged: onValueChanged,
      );
    }
  }
}
