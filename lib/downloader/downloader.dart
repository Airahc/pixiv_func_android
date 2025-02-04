/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:downloader.dart
 * 创建时间:2021/9/5 下午9:24
 * 作者:小草
 */
import 'dart:isolate';
import 'dart:typed_data';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:pixiv_func_android/api/entity/illust.dart';
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/model/download_task.dart';
import 'package:pixiv_func_android/util/utils.dart';

class Downloader {
  static int _idCount = 0;

  static int get _currentId => _idCount++;

  static final ReceivePort _hostReceivePort = ReceivePort()..listen(_hostReceive);

  static Future<void> _hostReceive(dynamic message) async {
    if (message is DownloadTask) {
      final index = downloadTaskModel.tasks.indexWhere((task) => message.filename == task.filename);
      if (-1 != index) {
        //如果存在
        downloadTaskModel.tasks[index] = message;
        downloadTaskModel.update(index, (task) {
          task.progress = message.progress;
          task.state = message.state;
        });
      } else {
        //如果不存在
        downloadTaskModel.add(message);
      }
    } else if (message is _DownloadComplete) {
      final saveResult = await platformAPI.saveImage(message.imageBytes, message.filename);
      if (null == saveResult) {
        platformAPI.toast('图片已经存在');
        return;
      }
      if (saveResult) {
        platformAPI.toast('保存成功');
      } else {
        platformAPI.toast('保存失败');
      }
    } else if (message is _DownloadError) {
      platformAPI.toast('下载失败');
    }
  }

  static Future<void> _task(_DownloadStartProps props) async {
    final httpClient = Dio(
      BaseOptions(
        headers: const {'Referer': 'https://app-api.pixiv.net/'},
        responseType: ResponseType.bytes,
        sendTimeout: 15000,
        receiveTimeout: 15000,
        connectTimeout: 15000,
      ),
    );
    (httpClient.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
      client.badCertificateCallback = (cert, host, port) {
        return true;
      };
    };

    if (null != props.illust) {
      final task = DownloadTask.create(
        id: props.id,
        illust: props.illust!,
        originalUrl: props.originalUrl,
        url: props.url,
        filename: props.filename,
      );
      task.state = DownloadState.downloading;
      props.hostSendPort.send(task);
      await httpClient.get<Uint8List>(
        props.url,
        onReceiveProgress: (int count, int total) {
          task.progress = count / total;
          props.hostSendPort.send(task);
        },
      ).then((result) async {
        task.state = DownloadState.complete;
        props.hostSendPort.send(_DownloadComplete(result.data!, props.filename));
        props.hostSendPort.send(task);
      }).catchError((e, s) async {
        task.state = DownloadState.failed;
        props.hostSendPort.send(task);
        props.hostSendPort.send(_DownloadError());
      });
    } else {
      await httpClient
          .get<Uint8List>(
        props.url,
      )
          .then((result) async {
        props.hostSendPort.send(_DownloadComplete(result.data!, props.filename));
      }).catchError((e, s) async {
        props.hostSendPort.send(_DownloadError());
      });
    }
  }

  static Future<void> start({
    Illust? illust,
    required String url,
    int? id,
  }) async {


    final filename = url.substring(url.lastIndexOf('/') + 1);
    final imageUrl = Utils.replaceImageSource(url);

    if (await platformAPI.imageIsExist(filename)) {
      platformAPI.toast('图片已经存在');
      return;
    }

    final taskIndex = downloadTaskModel.tasks.indexWhere((task) => filename == task.filename);
    if (-1 != taskIndex && DownloadState.failed != downloadTaskModel.tasks[taskIndex].state) {
      platformAPI.toast('下载任务已存在');
      return;
    }

    platformAPI.toast('开始下载');
    Isolate.spawn(
      _task,
      _DownloadStartProps(
        hostSendPort: _hostReceivePort.sendPort,
        id: id ?? _currentId,
        illust: illust,
        originalUrl: url,
        url: imageUrl,
        filename: filename,
      ),
      debugName: 'IsolateDebug',
    );
  }
}

class _DownloadStartProps {
  SendPort hostSendPort;
  int id;
  Illust? illust;
  String originalUrl;
  String url;
  String filename;

  _DownloadStartProps({
    required this.hostSendPort,
    required this.id,
    required this.illust,
    required this.originalUrl,
    required this.url,
    required this.filename,
  });
}

class _DownloadComplete {
  final Uint8List imageBytes;
  final String filename;

  _DownloadComplete(this.imageBytes, this.filename);
}

class _DownloadError {}
