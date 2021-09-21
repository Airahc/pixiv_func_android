/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:scroll_to_top_button.dart
 * 创建时间:2021/9/10 下午12:08
 * 作者:小草
 */
import 'package:flutter/material.dart';
import 'package:pixiv_func_android/provider/base_view_state_refresh_list_model.dart';

class ScrollToTopButton extends StatelessWidget {
  final BaseViewStateRefreshListModel model;

  const ScrollToTopButton(this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => model.scrollToTop(),
      child: const Icon(
        Icons.arrow_drop_up,
      ),
    );
  }
}
