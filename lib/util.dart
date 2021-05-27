/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : util.dart
 */

import 'dart:typed_data';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pixiv_xiaocao_android/api/entity/bookmark_add/bookmark_add.dart';
import 'package:pixiv_xiaocao_android/api/pixiv_request.dart';
import 'package:pixiv_xiaocao_android/config/config_util.dart';
import 'package:pixiv_xiaocao_android/log/log_entity.dart';
import 'package:pixiv_xiaocao_android/log/log_util.dart';
import 'package:pixiv_xiaocao_android/platform_util.dart';

import 'component/bookmark_add_dialog_content.dart';

class Util {
  static final storageStatus = Permission.storage.status;

  static void saveImage(int id, String url, String title) async {
    final imageName = url.substring(url.lastIndexOf('/') + 1);

    if (!await PlatformUtil.imageIsExist(imageName)) {
      final imageUrl = ConfigUtil.instance.config.enableImageProxy
          ? url.replaceFirst("i.pximg.net", "i.pixiv.cat")
          : url;
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
            if (!await PlatformUtil.imageIsExist(imageName)) {
              if (await PlatformUtil.saveImage(response.data!, imageName)) {
                toastIconAndText(Icons.save_alt_outlined, '图片保存成功');
                LogUtil.instance.add(
                  type: LogType.Info,
                  id: id,
                  title: title,
                  url: url,
                  context: '图片保存成功',
                );
              } else {
                toastIconAndText(Icons.save_alt_outlined, '图片保存失败');
                LogUtil.instance.add(
                  type: LogType.SaveFileFail,
                  id: id,
                  title: title,
                  url: url,
                  context: '图片保存失败',
                );
              }
            } else {
              toastIconAndText(Icons.error_outlined, '图片已经存在');
              LogUtil.instance.add(
                type: LogType.Info,
                id: id,
                title: title,
                url: url,
                context: '图片已经存在',
              );
            }
          } else {
            toastIconAndText(Icons.error_outlined, '图片下载失败');
            LogUtil.instance.add(
              type: LogType.DownloadFail,
              id: id,
              title: title,
              url: url,
              context: '图片下载失败',
            );
          }
        },
      ).catchError(
        (e) {
          toastIconAndText(Icons.error_outlined, '图片下载失败');
          LogUtil.instance.add(
              type: LogType.DownloadFail,
              id: id,
              title: title,
              url: url,
              context: '图片下载失败',
              exception: e);
        },
      );
    } else {
      toastIconAndText(Icons.error_outlined, '图片已经存在');
      LogUtil.instance.add(
        type: LogType.Info,
        id: id,
        title: title,
        url: url,
        context: '图片已经存在',
      );
    }
  }

  static void gotoPage(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => page,
    ));
  }

  static Future<void> copyToClipboard(String data) async {
    await Clipboard.setData(ClipboardData(text: data));
  }

  static Future<String?> readClipboard() async {
    final clipboard = await Clipboard.getData(Clipboard.kTextPlain);
    return clipboard?.text;
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

  static String dateTimeToString(DateTime dateTime) {
    return '${dateTime.year}年${dateTime.month}月${dateTime.day}日 ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
  }

  static Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static Size get windowSize => MediaQueryData.fromWindow(window).size;

  static Widget buildBookmarkButton(
    BuildContext context, {
    required int illustId,
    required int? bookmarkId,
    required void Function(int? bookmarkId) updateCallback,
  }) {
    return IconButton(
      splashRadius: 20,
      onPressed: () async {
        if (bookmarkId != null) {
          final bookmarkDelete =
              await PixivRequest.instance.bookmarkDelete(bookmarkId);
          if (bookmarkDelete != null) {
            if (!bookmarkDelete.error) {
              if (bookmarkDelete.isSucceed) {
                updateCallback.call(null);
              } else {
                Util.toast('删除书签失败');
                LogUtil.instance.add(
                  type: LogType.Info,
                  id: illustId,
                  title: '删除书签失败',
                  url: '',
                  context: '',
                );
              }
            } else {
              Util.toast(bookmarkDelete.message);
              LogUtil.instance.add(
                type: LogType.Info,
                id: illustId,
                title: '删除书签失败',
                url: '',
                context: 'error:${bookmarkDelete.message}',
              );
            }
          }
        } else {
          showDialog<Null>(
            context: context,
            builder: (context) {
              return BookmarkAddDialogContent(
                illustId,
                (BookmarkAdd? bookmarkAdd) {
                  if (bookmarkAdd != null) {
                    if (!bookmarkAdd.error) {
                      if (bookmarkAdd.isSucceed) {
                        updateCallback.call(bookmarkAdd.lastBookmarkId);
                      } else {
                        Util.toast('添加书签失败');
                        LogUtil.instance.add(
                          type: LogType.Info,
                          id: illustId,
                          title: '添加书签失败',
                          url: '',
                          context: '',
                        );
                      }
                    } else {
                      Util.toast(bookmarkAdd.message);
                      LogUtil.instance.add(
                        type: LogType.Info,
                        id: illustId,
                        title: '添加书签失败',
                        url: '',
                        context: 'error:${bookmarkAdd.message}',
                      );
                    }
                  }

                },
              );
            },
          );
        }
      },
      icon: Icon(
        bookmarkId != null
            ? Icons.favorite_sharp
            : Icons.favorite_outline_sharp,
        color: bookmarkId != null ? Colors.pinkAccent : Colors.white70,
      ),
    );
  }
}
