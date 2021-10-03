/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:novel_detail_model.dart
 * 创建时间:2021/10/3 下午9:38
 * 作者:小草
 */

import 'package:pixiv_func_android/api/entity/novel.dart';
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/log/log.dart';
import 'package:pixiv_func_android/provider/base_view_model.dart';
import 'package:pixiv_func_android/view_model/novel_previewer_model.dart';

class NovelDetailModel extends BaseViewModel {
  final NovelPreviewerModel previewerModel;

  NovelDetailModel(this.previewerModel);

  Novel get novel => previewerModel.novel;



  bool _showOriginalCaption = false;

  bool get bookmarkRequestWaiting => previewerModel.bookmarkRequestWaiting;

  set bookmarkRequestWaiting(bool value) {
    previewerModel.bookmarkRequestWaiting = value;
    notifyListeners();
  }

  bool get isBookmarked => novel.isBookmarked;

  set isBookmarked(bool value) {
    previewerModel.isBookmarked = value;
    notifyListeners();
  }

  bool get showOriginalCaption => _showOriginalCaption;

  set showOriginalCaption(bool value) {
    _showOriginalCaption = value;
    notifyListeners();
  }

  void bookmarkStateChange() {
    bookmarkRequestWaiting = true;
    if (!isBookmarked) {
      pixivAPI.bookmarkAdd(novel.id, isNovel: true).then((result) {
        isBookmarked = true;
      }).catchError((e) {
        Log.e('添加书签失败', e);
      }).whenComplete(() => bookmarkRequestWaiting = false);
    } else {
      pixivAPI.bookmarkDelete(novel.id, isNovel: true).then((result) {
        isBookmarked = false;
      }).catchError((e) {
        Log.e('删除书签失败', e);
      }).whenComplete(() => bookmarkRequestWaiting = false);
    }
  }
}
