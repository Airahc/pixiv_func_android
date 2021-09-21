/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:download_task.dart
 * 创建时间:2021/9/5 下午11:39
 * 作者:小草
 */

import 'package:pixiv_func_android/api/entity/illust.dart';

enum DownloadState {
  Idle,
  Downloading,
  Failed,
  Complete,
}

class DownloadTask {
  int id;
  Illust illust;
  String url;
  String filename;
  double progress;
  DownloadState state;

  DownloadTask(this.id, this.illust, this.url, this.filename, this.progress, this.state);

  factory DownloadTask.create({
    required int id,
    required Illust illust,
    required String uri,
    required String filename,
  }) =>
      DownloadTask(id, illust, uri, filename, 0, DownloadState.Idle);

  @override
  String toString() {
    return 'DownloadTask{uri: $url, filename: $filename, progress: $progress, state: $state}';
  }
}
