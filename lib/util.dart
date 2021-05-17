/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : util.dart
 */

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pixiv_xiaocao_android/api/entity/user_works/work.dart';
import 'package:pixiv_xiaocao_android/api/pixiv_request.dart';
import 'package:pixiv_xiaocao_android/config.dart';
import 'package:pixiv_xiaocao_android/platform_util.dart';

class Util {

  static void updateConfig<T>(String name, T value) {
    final configFile =
        File('/storage/emulated/0/pixiv_xiaocao_android/Config.json');

    ///不存在先创建一个
    if (!configFile.existsSync()) {
      configFile.createSync(recursive: true);
      configFile.writeAsStringSync({}.toString());
    }
    var content = configFile.readAsStringSync();

    var config = jsonDecode(content);
    config[name] = value;
    configFile.writeAsStringSync(jsonEncode(config));
  }

  static T getConfig<T>(String name, {required T defaultValue}) {
    final configFile =
        File('/storage/emulated/0/pixiv_xiaocao_android/Config.json');
    if (configFile.existsSync()) {
      var config = jsonDecode(configFile.readAsStringSync());
      var value = config[name];
      return value != null && value is T ? value : defaultValue;
    } else {
      return defaultValue;
    }
  }

  static void gotoPage(BuildContext context, Widget page) {
    Navigator.of(context).push(CupertinoPageRoute(
      builder: (context) => page,
    ));
  }

  static void copyToClipboard(String data) {
    Clipboard.setData(ClipboardData(text: data));
  }

  static void showSnackBar(BuildContext context, Widget content) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: content));
  }

  static void toastIconAndText(
    IconData iconData,
    String text, {
    ToastPosition position = ToastPosition.bottom,
    Duration? duration,
  }) {
    showToastWidget(
      Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          color: Colors.black54,
          child: Row(
            children: [
              Icon(
                iconData,
                color: Colors.white,
              ),
              Text(text)
            ],
            mainAxisSize: MainAxisSize.min,
          ),
        ),
      ),
      position: position,
      duration: duration == null ? Duration(seconds: 3) : duration,
    );
  }

  static void toastWidget(
    Widget child, {
    ToastPosition position = ToastPosition.bottom,
    Duration? duration,
  }) {
    showToastWidget(
      child,
      position: position,
      duration: duration == null ? Duration(seconds: 3) : duration,
    );
  }

  static void toast(
    String text, {
    ToastPosition position = ToastPosition.bottom,
    Duration? duration,
    TextStyle? textStyle,
    Color? backgroundColor,
  }) {
    showToast(
      text,
      position: position,
      duration: duration == null ? Duration(seconds: 3) : duration,
      textStyle: textStyle,
      backgroundColor: backgroundColor,
    );
  }

  static String timestampToDateTimeString(int timestamp) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${dateTime.year}年${dateTime.month}月${dateTime.day}日 ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
  }

  static String dateTimeToString(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString);
    return '${dateTime.year}年${dateTime.month}月${dateTime.day}日';
  }

  static void saveImage(int illustId, String url, int userId) async {
    final imageUrl = Config.enableImageProxy
        ? url.replaceFirst("i.pximg.net", "i.pixiv.cat")
        : url;

    final imageName = imageUrl.substring(imageUrl.lastIndexOf('/') + 1);
    if (!await PlatformUtil.imageIsExist(imageName)) {
      final httpClient = Dio()
        ..options.headers = {'Referer': 'https://pixiv.net'}
        ..options.responseType = ResponseType.bytes;
      (httpClient.httpClientAdapter as DefaultHttpClientAdapter)
          .onHttpClientCreate = (client) {
        HttpClient httpClient = new HttpClient();
        httpClient.badCertificateCallback =
            (X509Certificate cert, String host, int port) {
          return true;
        };
        return httpClient;
      };

      httpClient.get<Uint8List>(imageUrl).then(
        (response) async {
          if (response.data != null) {
            if (await PlatformUtil.saveImage(response.data!, imageName)) {
              toastIconAndText(Icons.save_alt, '保存成功');
            } else {
              toastIconAndText(Icons.save_alt, '保存失败');
            }
          }
        },
      ).catchError((error) {
        toastIconAndText(Icons.error_outlined, '下载失败');
      });
    } else {
      toastIconAndText(Icons.announcement_outlined, '已经存在');
    }
  }

  static void saveIllust(int illustId) {
    PixivRequest.instance.queryIllustInfo(illustId).then((data) {
      var illustInfo = data;

      if (illustInfo?.body != null) {
        late int userId;
        try {
          userId = illustInfo!.body!.authorDetails.userId;
        } catch (e) {
          throw '获取用户id异常';
        }

        if (illustInfo.body!.illustDetails.mangaA != null) {
          //插画不是只有一个
          illustInfo.body!.illustDetails.mangaA!.forEach((illust) {
            saveImage(illustId, illust.urlBig, userId);
          });
        } else {
          //插画只有一个
          saveImage(illustId, illustInfo.body!.illustDetails.urlBig!, userId);
        }
      }
    }).catchError((error) {
      print(error);
    });
  }

  static void saveUserAllIllust(List<Work> works) {
    works.forEach((work) {
      saveIllust(work.id);
    });
  }

  static void checkPermissionStatus() async {
    final status = Permission.storage.status;
    if (await status.isDenied) {
      if (await Permission.storage.request().isGranted) {
        print('被授予权限');
      }
    } else if (await status.isGranted) {
      print('有权限');
    }
  }

  static Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static Size get windowSize => MediaQueryData.fromWindow(window).size;
}
