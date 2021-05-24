/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : segment_bar.dart
 */

import 'package:flutter/material.dart';

class SegmentBarView<T> extends StatelessWidget {
  final List<String> items;
  final List<T> values;
  final void Function(T) onSelected;
  final T selectedValue;

  SegmentBarView({
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
          onPressed: () {},
          child: Text(
            item,
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    } else {
      return Container(
        height: 34,
        child: OutlinedButton(
          onPressed: () {
            if (value != selectedValue) {
              onSelected.call(value);
            }
          },
          child: Text(item),
        ),
      );
    }
  }
}
