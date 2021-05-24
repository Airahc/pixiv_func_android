/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : log_entity.dart
 */

enum LogType {
  NetworkException,
  DeserializationException,
  DownloadFail,
  SaveFileFail,
  Info,
}

class LogEntity {
  DateTime dateTime;
  LogType type;
  int id;
  String title;
  String url;
  String context;
  Exception? exception;

  LogEntity(this.dateTime, this.type, this.id, this.title, this.url,
      this.context, this.exception);

  @override
  String toString() {
    return 'dateTime: $dateTime, type: $type, id: $id, title: $title, url: $url, context: $context, exception: $exception';
  }
}
