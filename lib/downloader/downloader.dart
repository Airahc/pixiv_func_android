/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:downloader.dart
 * 创建时间:2021/9/5 下午9:24
 * 作者:小草
 */
import 'dart:isolate';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:pixiv_func_android/api/entity/illust.dart';
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/model/download_task.dart';

class Downloader {
  static const _TARGET_HOST = 'i.pximg.net';

  static int _idCount = 0;

  static int get _currentId => _idCount++;

  static final ReceivePort _hostReceivePort = ReceivePort()..listen(_hostReceive);

  static Future<void> _hostReceive(dynamic message) async {
    if (message is DownloadTask) {
      final index = downloadTaskModel.tasks.indexWhere((task) => message.id == task.id);
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
        await platformAPI.toast('图片已经存在');
        return;
      }
      if (saveResult) {
        await platformAPI.toast('保存成功');
      } else {
        await platformAPI.toast('保存失败');
      }
    } else if (message is _DownloadError) {
      await platformAPI.toast('下载失败');
    }
  }

  static Future<void> _task(_DownloadStartProps props) async {
    final httpClient = Dio(
      BaseOptions(
        headers: {'Referer': 'https://app-api.pixiv.net/'},
        responseType: ResponseType.bytes,
        sendTimeout: 15000,
        receiveTimeout: 15000,
        connectTimeout: 15000,
      ),
    );
    if(null!=props.illust){
      final task = DownloadTask.create(
        id: props.id,
        illust: props.illust!,
        uri: props.url,
        filename: props.filename,
      );
      task.state = DownloadState.Downloading;
      props.hostSendPort.send(task);
      await httpClient.get<Uint8List>(
        props.url,
        onReceiveProgress: (int count, int total) {
          task.progress = count / total;
          props.hostSendPort.send(task);
        },
      ).then((result) async {
        task.state = DownloadState.Complete;
        props.hostSendPort.send(_DownloadComplete(result.data!, props.filename));
        props.hostSendPort.send(task);
      }).catchError((e, s) async {
        task.state = DownloadState.Failed;
        props.hostSendPort.send(task);
        props.hostSendPort.send(_DownloadError());
      });
    }else{
      await httpClient.get<Uint8List>(
        props.url,
      ).then((result) async {
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
    final imageUrl = url.replaceFirst(_TARGET_HOST, settingsManager.imageSource);
    if (await platformAPI.imageIsExist(filename)) {
      await platformAPI.toast('图片已经存在');
      return;
    }
    await platformAPI.toast('开始下载');
    Isolate.spawn(
      _task,
      _DownloadStartProps(
        hostSendPort: _hostReceivePort.sendPort,
        id: id ?? _currentId,
        illust: illust,
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
  String url;
  String filename;

  _DownloadStartProps({
    required this.hostSendPort,
    required this.id,
    required this.illust,
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
