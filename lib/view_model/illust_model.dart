/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:illust_model.dart
 * 创建时间:2021/8/26 下午8:32
 * 作者:小草
 */

import 'package:pixiv_func_android/api/entity/illust.dart';
import 'package:pixiv_func_android/api/model/illusts.dart';
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/log/log.dart';
import 'package:pixiv_func_android/provider/base_view_state_list_model.dart';
import 'package:pixiv_func_android/view_model/illust_previewer_model.dart';

class IllustModel extends BaseViewStateListModel<Illust> {
  Illust illust;

  IllustModel(this.illust);

  bool _showOriginalCaption = false;

  bool _bookmarkRequestWaiting = false;

  bool get showOriginalCaption => _showOriginalCaption;

  set showOriginalCaption(bool value) {
    _showOriginalCaption = value;
    notifyListeners();
  }

  bool get bookmarkRequestWaiting => _bookmarkRequestWaiting;

  set bookmarkRequestWaiting(bool value) {
    _bookmarkRequestWaiting = value;
    notifyListeners();
  }

  set isBookmarked(bool value) {
    illust.isBookmarked = value;
    notifyListeners();
  }

  void loadFirstData() {
    setBusy();

    pixivAPI.getIllustRelated(illust.id).then((result) {
      if (result.illusts.isNotEmpty) {
        list.addAll(result.illusts);
        setIdle();
      } else {
        setEmpty();
      }

      nextUrl = result.nextUrl;
      initialized = true;
    }).catchError((e, s) {
      Log.e('首次加载数据异常', e);
      setInitFailed(e, s);
    });
  }

  void loadNextData() {
    setBusy();
    pixivAPI.next<Illusts>(nextUrl!).then((result) {
      list.addAll(result.illusts);
      nextUrl = result.nextUrl;
      setIdle();
    }).catchError((e) {
      Log.e('加载下一条数据异常', e);
      setLoadFailed();
    });
  }

  void onBookmarkStateChange(IllustPreviewerModel? parentModel) {
    bookmarkRequestWaiting = true;
    if (!illust.isBookmarked) {
      pixivAPI.bookmarkAdd(illust.id).then((result) {
        isBookmarked = true;
        parentModel?.isBookmarked = true;
      }).catchError((e) {
        Log.e('添加书签失败', e);
      }).whenComplete(() => bookmarkRequestWaiting = false);
    } else {
      pixivAPI.bookmarkDelete(illust.id).then((result) {
        isBookmarked = false;
        parentModel?.isBookmarked = false;
      }).catchError((e) {
        Log.e('删除书签失败', e);
      }).whenComplete(() => bookmarkRequestWaiting = false);
    }
  }
}
