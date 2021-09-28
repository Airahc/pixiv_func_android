/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:base_view_state_model.dart
 * 创建时间:2021/8/22 下午11:55
 * 作者:小草
 */


import 'package:pixiv_func_android/provider/base_view_model.dart';
import 'package:pixiv_func_android/provider/view_state.dart';

abstract class BaseViewStateModel extends BaseViewModel {
  ViewState _viewState = ViewState.idle;

  ///已经初始化
  bool initialized = false;

  ViewState get viewState => _viewState;

  set viewState(ViewState value) {
    _viewState = value;
    notifyListeners();
  }

  void setIdle() => viewState = ViewState.idle;

  void setBusy() => viewState = ViewState.busy;

  void setEmpty() => viewState = ViewState.empty;

  void setInitFailed(dynamic e,dynamic s) {
    viewState = ViewState.initFailed;
  }

  void setLoadFailed() => viewState = ViewState.loadFailed;

}
