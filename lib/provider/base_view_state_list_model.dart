/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:base_view_state_refresh_list_model.dart
 * 创建时间:2021/8/23 上午12:17
 * 作者:小草
 */


import 'package:pixiv_func_android/provider/base_view_state_model.dart';

abstract class BaseViewStateListModel<T> extends BaseViewStateModel {

  List<T> list = <T>[];

  String? nextUrl;

  bool get hasNext => null != nextUrl;

}
