/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:user_model.dart
 * 创建时间:2021/8/30 下午11:08
 * 作者:小草
 */

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pixiv_func_android/api/model/user_detail.dart';
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/log/log.dart';
import 'package:pixiv_func_android/provider/base_view_state_model.dart';
import 'package:pixiv_func_android/view_model/user_preview_model.dart';

class UserModel extends BaseViewStateModel {
  final int _userId;
  UserDetail? userDetail;

  UserModel(this._userId);

  int _index = 0;

  int get index => _index;

  set index(int value) {
    if (value != _index) {
      _index = value;
      notifyListeners();
    }
  }

  bool _followRequestWaiting = false;

  bool get followRequestWaiting => _followRequestWaiting;

  set followRequestWaiting(bool value) {
    _followRequestWaiting = value;
    notifyListeners();
  }

  bool get isFollowed => userDetail!.user.isFollowed == true;

  set isFollowed(bool value) {
    userDetail!.user.isFollowed = value;
    notifyListeners();
  }

  void onFollowStateChange(UserPreviewModel? parentModel) {
    followRequestWaiting = true;
    if (!isFollowed) {
      pixivAPI.followAdd(userDetail!.user.id).then((result) {
        isFollowed = true;
        parentModel?.isFollowed = true;
      }).catchError((e) {
        Log.e('添加关注失败', e);
      }).whenComplete(() => followRequestWaiting = false);
    } else {
      pixivAPI.followDelete(userDetail!.user.id).then((result) {
        isFollowed = false;
        parentModel?.isFollowed = false;
      }).catchError((e) {
        Log.e('删除关注失败', e);

      }).whenComplete(() => followRequestWaiting = false);
    }
  }

  void loadData() async {
    userDetail = null;
    setBusy();

    pixivAPI.getUserDetail(_userId).then((result) {
      userDetail = result;
      setIdle();
    }).catchError((e, s) {
      if (e is DioError && e.response?.statusCode == HttpStatus.notFound) {
        setEmpty();
      } else {
        setInitFailed(e, s);
      }
    });
  }
}
