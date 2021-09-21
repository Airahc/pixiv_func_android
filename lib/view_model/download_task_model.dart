/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:download_task_model.dart
 * 创建时间:2021/9/5 下午11:47
 * 作者:小草
 */

import 'package:pixiv_func_android/model/download_task.dart';
import 'package:pixiv_func_android/provider/base_view_model.dart';


class DownloadTaskModel extends BaseViewModel {
  final List<DownloadTask> _tasks = [];

  void add(DownloadTask task) {
    _tasks.add(task);
    notifyListeners();
  }

  void update(int index, void Function(DownloadTask task) change) {
    change(tasks[index]);
    notifyListeners();
  }

  List<DownloadTask> get tasks => _tasks;
}
