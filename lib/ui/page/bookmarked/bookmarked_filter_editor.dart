/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:bookmarked_filter_editor.dart
 * 创建时间:2021/10/4 下午2:56
 * 作者:小草
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pixiv_func_android/model/bookmarked_filter.dart';
import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/ui/widget/sliding_segmented_control.dart';
import 'package:pixiv_func_android/view_model/bookmarked_filter_model.dart';

class BookmarkedFilterEditor extends StatelessWidget {
  final BookmarkedFilter filter;
  final ValueChanged<BookmarkedFilter> onChanged;

  const BookmarkedFilterEditor({Key? key, required this.filter, required this.onChanged}) : super(key: key);

  Widget _buildSearchSortEdit(BookmarkedFilterModel model) {
    return SlidingSegmentedControl(
      children: const <bool, Widget>{
        true: Text('公开'),
        false:  Text('私有'),
      },
      groupValue: model.restrict,
      onValueChanged: (bool? value) {
        if (null != value) {
          model.restrict = value;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      model: BookmarkedFilterModel(filter),
      builder: (BuildContext context, BookmarkedFilterModel model, Widget? child) {
        return Container(
          height: 450,
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Column(
            children: [
              _buildSearchSortEdit(model),
              OutlinedButton(
                onPressed: () {
                  onChanged(model.filter);
                  Navigator.of(context).pop();
                },
                child: const Text('确定'),
              ),
            ],
          ),
        );
      },
    );
  }
}
