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
  ViewState _viewState = ViewState.Idle;

  ///已经初始化
  bool initialized = false;

  ViewState get viewState => _viewState;

  set viewState(ViewState value) {
    _viewState = value;
    notifyListeners();
  }

  void setIdle() => viewState = ViewState.Idle;

  void setBusy() => viewState = ViewState.Busy;

  void setEmpty() => viewState = ViewState.Empty;

  void setInitFailed(dynamic e,dynamic s) {
    viewState = ViewState.InitFailed;
  }

  void setLoadFailed() => viewState = ViewState.LoadFailed;

}
