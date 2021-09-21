/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:base_view_state_refresh_list_model.dart
 * 创建时间:2021/8/23 上午12:17
 * 作者:小草
 */

import 'package:flutter/cupertino.dart';
import 'package:pixiv_func_android/log/log.dart';
import 'package:pixiv_func_android/provider/base_view_state_list_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:async/async.dart';

abstract class BaseViewStateRefreshListModel<T> extends BaseViewStateListModel<T> {
  RefreshController refreshController = RefreshController(initialRefresh: true);
  ScrollController scrollController = ScrollController();

  bool _showToTop = false;

  bool get showToTop => _showToTop;

  set showToTop(bool value) {
    _showToTop = value;
    notifyListeners();
  }

  CancelableOperation<List<T>>? cancelableTask;

  BaseViewStateRefreshListModel() {
    scrollController.addListener(scrollEvent);
  }

  void scrollEvent() {
    if (scrollController.hasClients) {
      final show = scrollController.offset > 1200;
      if (show != showToTop) {
        showToTop = show;
      }
    }
  }

  @override
  void dispose() {
    cancelTask();
    super.dispose();
  }

  void scrollToTop() {
    if (scrollController.hasClients) {
      if (scrollController.offset != 0) {
        scrollController.animateTo(
          0,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInQuad,
        );
      }
    }
  }

  void cancelTask() {
    cancelableTask?.cancel();
    cancelableTask = null;
  }

  void refresh() {
    cancelTask();
    refreshController.refreshToIdle();
    refreshController.requestRefresh();
  }

  ///刷新
  void refreshRoutine() {
    initialized = false;
    nextUrl = null;
    list.clear();
    setBusy();
    cancelableTask = CancelableOperation.fromFuture(loadFirstDataRoutine());
    cancelableTask?.value.then((result) {
      refreshController.refreshCompleted();
      if (!hasNext) {
        refreshController.loadNoData();
      }
      initialized = true;
      if (result.isEmpty) {
        setEmpty();
      } else {
        list.addAll(result);
        setIdle();
      }

    }).catchError((e, s) {
      refreshController.refreshFailed();
      Log.e('异常', e, s);

      setInitFailed(e, s);
    });
  }

  ///加载下一页
  void nextRoutine() async {
    if (hasNext) {
      setBusy();
      cancelableTask = CancelableOperation.fromFuture(loadNextDataRoutine());
      cancelableTask?.value.then((result) {
        list.addAll(result);
        if (hasNext) {
          refreshController.loadComplete();
        } else {
          refreshController.loadNoData();
        }
      }).catchError((e, s) {
        Log.d('异常', e, s);
        refreshController.loadFailed();
      }).whenComplete(() => setIdle());
    }
  }

  ///内部使用
  ///
  ///首次加载数据的实现
  Future<List<T>> loadFirstDataRoutine();

  ///内部使用
  ///
  ///加载下一条数据的实现
  Future<List<T>> loadNextDataRoutine();
}
