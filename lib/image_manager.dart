/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : image_manager.dart
 */

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pixiv_xiaocao_android/config/config_util.dart';
import 'package:pixiv_xiaocao_android/log/log_entity.dart';
import 'package:pixiv_xiaocao_android/log/log_util.dart';
import 'package:pixiv_xiaocao_android/platform_util.dart';
import 'package:pixiv_xiaocao_android/utils.dart';

class SaveImageTask {
  int id;
  String url;
  String title;

  SaveImageTask({required this.id, required this.url, required this.title});
}

class ImageManager {
  static Future<void> save(SaveImageTask saveTask) async {
    final imageName = saveTask.url.substring(saveTask.url.lastIndexOf('/') + 1);

    if (await PlatformUtil.imageIsExist(imageName)) {
      Utils.toastIconAndText(Icons.error_outlined, '图片已经存在');
      LogUtil.instance.add(
        type: LogType.Info,
        id: saveTask.id,
        title: saveTask.title,
        url: saveTask.url,
        context: '图片已经存在',
      );
    } else {
      final imageUrl = ConfigUtil.instance.config.enableImageProxy
          ? saveTask.url.replaceFirst("i.pximg.net", "i.pixiv.cat")
          : saveTask.url;
      final httpClient = Dio()
        ..options.responseType = ResponseType.bytes
        ..options.sendTimeout = 1000 * 15
        ..options.receiveTimeout = 1000 * 15
        ..options.connectTimeout = 1000 * 10
        ..options.headers = {
          'Referer': 'https://pixiv.net/',
          'User-Agent': ConfigUtil.userAgent
        };

      httpClient.get<Uint8List>(imageUrl).then(
        (response) async {
          if (response.data != null) {
            final saveResult =
                await PlatformUtil.saveImage(response.data!, imageName);
            if (saveResult != null) {
              if (saveResult) {
                Utils.toastIconAndText(Icons.save_alt_outlined, '图片保存成功');
                LogUtil.instance.add(
                  type: LogType.Info,
                  id: saveTask.id,
                  title: saveTask.title,
                  url: saveTask.url,
                  context: '图片保存成功',
                );
              } else {
                Utils.toastIconAndText(Icons.save_alt_outlined, '图片保存失败');
                LogUtil.instance.add(
                  type: LogType.SaveFileFail,
                  id: saveTask.id,
                  title: saveTask.title,
                  url: saveTask.url,
                  context: '图片保存失败',
                );
              }
            } else {
              Utils.toastIconAndText(Icons.error_outlined, '图片已经存在');
              LogUtil.instance.add(
                type: LogType.Info,
                id: saveTask.id,
                title: saveTask.title,
                url: saveTask.url,
                context: '图片已经存在',
              );
            }
          }
        },
      ).catchError(
        (e) {
          Utils.toastIconAndText(Icons.error_outlined, '图片下载失败');
          LogUtil.instance.add(
            type: LogType.DownloadFail,
            id: saveTask.id,
            title: saveTask.title,
            url: saveTask.url,
            context: '图片下载失败',
            exception: e,
          );
        },
      );
    }
  }
}
