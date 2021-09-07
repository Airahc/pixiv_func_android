/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_android
 * 文件名称:dropdown_menu.dart
 * 创建时间:2021/9/4 上午10:13
 * 作者:小草
 */
import 'package:flutter/material.dart';
import 'package:pixiv_func_android/model/dropdown_item.dart';

class DropdownMenu<T> extends StatelessWidget {
  final List<DropdownItem> menuItems;
  final T currentValue;
  final ValueChanged<T?> onChanged;

  DropdownMenu({
    Key? key,
    required this.menuItems,
    required this.currentValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      items: menuItems.map((e) {
        return DropdownMenuItem<T>(
          child: Text(
            e.label,
            style: currentValue == e.value ? TextStyle(color: Theme.of(context).colorScheme.primary) : null,
          ),
          value: e.value,
        );
      }).toList(),
      value: currentValue,
      onChanged: onChanged,
    );
  }
}
