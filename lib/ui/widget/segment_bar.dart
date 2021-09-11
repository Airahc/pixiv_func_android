/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:segment_bar.dart
 * 创建时间:2021/8/29 上午11:06
 * 作者:小草
 */

import 'package:flutter/material.dart';

class SegmentBar<T> extends StatelessWidget {
  final List<String> items;
  final List<T> values;
  final void Function(T) onSelected;
  final T selectedValue;

  SegmentBar({
    required this.items,
    required this.values,
    required this.onSelected,
    required this.selectedValue,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5,
      alignment: WrapAlignment.center,
      children: _buildSegments(),
    );
  }

  List<Widget> _buildSegments() {
    final list = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      list.add(
        Container(
          padding: EdgeInsets.only(top: 8, bottom: 8),
          child: _buildItem(items[i], values[i]),
        ),
      );
    }
    return list;
  }

  Widget _buildItem(String item, T value) {
    if (selectedValue == value) {
      return Container(
        height: 34,
        child: ElevatedButton(
          onPressed: () => onSelected.call(value),
          child: Text(item),
        ),
      );
    } else {
      return Container(
        height: 34,
        child: OutlinedButton(
          onPressed: () => onSelected.call(value),
          child: Text(item),
        ),
      );
    }
  }
}
