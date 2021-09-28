/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:download_task.dart
 * 创建时间:2021/9/5 下午11:39
 * 作者:小草
 */

import 'package:pixiv_func_android/api/entity/illust.dart';

enum DownloadState {
  idle,
  downloading,
  failed,
  complete,
}

class DownloadTask {
  int id;
  Illust illust;
  String originalUrl;
  String url;
  String filename;
  double progress;
  DownloadState state;

  DownloadTask(this.id, this.illust,this.originalUrl, this.url, this.filename, this.progress, this.state);

  factory DownloadTask.create({
    required int id,
    required Illust illust,
    required String originalUrl,
    required String url,
    required String filename,
  }) =>
      DownloadTask(id, illust,originalUrl, url, filename, 0, DownloadState.idle);

  @override
  String toString() {
    return 'DownloadTask{uri: $url, filename: $filename, progress: $progress, state: $state}';
  }
}
