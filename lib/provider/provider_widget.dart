/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:provider_widget.dart
 * 创建时间:2021/8/23 上午9:47
 * 作者:小草
 */

import 'package:flutter/cupertino.dart';
import 'package:pixiv_func_android/provider/base_view_model.dart';
import 'package:provider/provider.dart';

class ProviderWidget<T extends BaseViewModel> extends StatefulWidget {
  final T model;
  final ValueWidgetBuilder<T> builder;
  final Widget? child;
  final Function(T model)? onModelReady;
  final bool autoDispose;

  ProviderWidget({
    Key? key,
    required this.model,
    required this.builder,
    this.child,
    this.onModelReady,
    this.autoDispose: true,
  }) : super(key: key);

  _ProviderWidgetState<T> createState() => _ProviderWidgetState<T>();
}

class _ProviderWidgetState<T extends BaseViewModel> extends State<ProviderWidget<T>> {
  late T model;

  @override
  void initState() {
    model = widget.model;
    widget.onModelReady?.call(model);
    super.initState();
  }

  @override
  void dispose() {
    if (widget.autoDispose) model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider<T>.value(
      value: model,
      child: Consumer<T>(
        builder: widget.builder,
        child: widget.child,
      ),
    );
  }
}
