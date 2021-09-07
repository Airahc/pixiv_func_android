/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:user_preview_model.dart
 * 创建时间:2021/8/29 下午11:45
 * 作者:小草
 */

import 'package:pixiv_func_android/api/entity/user_preview.dart';
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/log/log.dart';
import 'package:pixiv_func_android/provider/base_view_model.dart';

class UserPreviewModel extends BaseViewModel {
  final UserPreview userPreview;

  UserPreviewModel(this.userPreview);

  bool _followRequestWaiting = false;

  bool get followRequestWaiting => _followRequestWaiting;

  set followRequestWaiting(bool value) {
    _followRequestWaiting = value;
    notifyListeners();
  }

  bool get isFollowed => userPreview.user.isFollowed!;

  set isFollowed(bool value){
    userPreview.user.isFollowed = value;
    notifyListeners();
  }

  void onFollowStateChange() {
    followRequestWaiting = true;
    if (!isFollowed) {
      pixivAPI.followAdd(userPreview.user.id).then((result) {
        isFollowed = true;
      }).catchError((e) {
        Log.e('添加书签失败', e);
      }).whenComplete(() => followRequestWaiting = false);
    } else {
      pixivAPI.followDelete(userPreview.user.id).then((result) {
        isFollowed = false;
      }).catchError((e) {
        Log.e('删除书签失败', e);
      }).whenComplete(() => followRequestWaiting = false);
    }
  }

}
