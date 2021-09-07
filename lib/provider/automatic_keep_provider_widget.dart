/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:automatic_keep_provider_widget.dart
 * 创建时间:2021/8/31 下午5:36
 * 作者:小草
 */

import 'package:flutter/cupertino.dart';
import 'package:pixiv_func_android/provider/base_view_model.dart';
import 'package:provider/provider.dart';

class AutomaticKeepProviderWidget<T extends BaseViewModel> extends StatefulWidget {
  final T model;
  final ValueWidgetBuilder<T> builder;
  final Widget? child;
  final Function(T model)? onModelReady;
  final bool autoDispose;

  AutomaticKeepProviderWidget({
    Key? key,
    required this.model,
    required this.builder,
    this.child,
    this.onModelReady,
    this.autoDispose: true,
  }) : super(key: key);

  _AutomaticKeepProviderWidgetState<T> createState() => _AutomaticKeepProviderWidgetState<T>();
}

class _AutomaticKeepProviderWidgetState<T extends BaseViewModel> extends State<AutomaticKeepProviderWidget<T>>
    with AutomaticKeepAliveClientMixin {
  late T model;

  @override
  bool get wantKeepAlive => true;

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
    super.build(context);
    return ChangeNotifierProvider<T>.value(
      value: model,
      child: Consumer<T>(
        builder: widget.builder,
        child: widget.child,
      ),
    );
  }
}
