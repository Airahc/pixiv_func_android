/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:illust_previewer_model.dart
 * 创建时间:2021/8/25 下午7:34
 * 作者:小草
 */

import 'package:pixiv_func_android/api/entity/illust.dart';
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/log/log.dart';
import 'package:pixiv_func_android/provider/base_view_model.dart';
import 'package:pixiv_func_android/view_model/illust_content_model.dart';

class IllustPreviewerModel extends BaseViewModel {
  final Illust illust;
  final IllustContentModel? _illustContentModel;

  IllustPreviewerModel(this.illust, {IllustContentModel? illustContentModel})
      : _illustContentModel = illustContentModel;

  bool get isR18 => illust.tags.any((tag) => tag.name == 'R-18');

  bool get isUgoira => 'ugoira' == illust.type;

  bool _bookmarkRequestWaiting = false;

  bool get bookmarkRequestWaiting => _bookmarkRequestWaiting;

  set bookmarkRequestWaiting(bool value) {
    _bookmarkRequestWaiting = value;
    notifyListeners();
  }

  bool get isBookmarked => illust.isBookmarked;

  set isBookmarked(bool value) {
    illust.isBookmarked = value;
    if (_illustContentModel?.illust.id == illust.id) {
      _illustContentModel?.isBookmarked = value;
    }
    notifyListeners();
  }

  void bookmarkStateChange() {
    bookmarkRequestWaiting = true;
    if (!isBookmarked) {
      pixivAPI.bookmarkAdd(illust.id).then((result) {
        isBookmarked = true;
      }).catchError((e) {
        Log.e('添加书签失败', e);
      }).whenComplete(() => bookmarkRequestWaiting = false);
    } else {
      pixivAPI.bookmarkDelete(illust.id).then((result) {
        isBookmarked = false;
      }).catchError((e) {
        Log.e('删除书签失败', e);
      }).whenComplete(() => bookmarkRequestWaiting = false);
    }
  }
}
