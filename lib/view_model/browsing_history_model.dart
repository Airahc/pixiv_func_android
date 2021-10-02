/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:browsing_history_model.dart
 * 创建时间:2021/10/2 上午10:08
 * 作者:小草
 */

import 'package:pixiv_func_android/api/entity/illust.dart';
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/log/log.dart';
import 'package:pixiv_func_android/provider/base_view_model.dart';

class BrowsingHistoryModel extends BaseViewModel {
  static const _limit = 30;

  final List<Illust> list = [];

  int _offset = 0;

  int _total = 0;

  bool get hasNext => offset < _total;

  int get offset => _offset;

  set offset(int value) {
    _offset = value;
    notifyListeners();
  }

  Future<void> init() async {
    _total = await browsingHistoryManager.count();
    await loadData();
  }

  Future<void> loadData() async {
    if (hasNext) {
      await browsingHistoryManager.query(offset, _limit).then((result) {
        offset += result.length;
        list.addAll(result);
        notifyListeners();
      }).catchError((e) {
        Log.e('加载数据 SQL异常', e);
      });
    }
  }

  Future<void> remove(int illustId) async {
    await browsingHistoryManager.delete(illustId).then((column) {
      if (column > 0) {
        list.removeWhere((illust) => illustId == illust.id);
        notifyListeners();
      } else {
        platformAPI.toast('删除历史记录$illustId失败');
      }
    }).catchError((e) {
      Log.e('删除历史记录$illustId失败 SQL异常');
    });
  }

  Future<void> clear() async {
    await browsingHistoryManager.clear();
    platformAPI.toast('历史记录已清空');
    _total = 0;
    list.clear();
    notifyListeners();
  }
}
