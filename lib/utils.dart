/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : utils.dart
 */
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html/parser.dart' show parse;
import 'package:image_picker/image_picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pixiv_xiaocao_android/api/entity/bookmark_add/bookmark_add.dart';
import 'package:pixiv_xiaocao_android/api/pixiv_request.dart';
import 'package:pixiv_xiaocao_android/component/bookmark_add_dialog_content.dart';
import 'package:pixiv_xiaocao_android/log/log_entity.dart';
import 'package:pixiv_xiaocao_android/log/log_util.dart';

class Utils {
  static final storageStatus = Permission.storage.status;

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
                Utils.toast('删除书签失败');
                LogUtil.instance.add(
                  type: LogType.Info,
                  id: illustId,
                  title: '删除书签失败',
                  url: '',
                  context: '',
                );
              }
            } else {
              Utils.toast(bookmarkDelete.message);
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
                        Utils.toast('添加书签失败');
                        LogUtil.instance.add(
                          type: LogType.Info,
                          id: illustId,
                          title: '添加书签失败',
                          url: '',
                          context: '',
                        );
                      }
                    } else {
                      Utils.toast(bookmarkAdd.message);
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

  static Future<List<int>> searchIdsByImage() async {
    final ids = <int>[];

    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final imageBytes = await pickedFile.readAsBytes();

      final httpClient = Dio()
        ..options.responseType = ResponseType.bytes
        ..options.sendTimeout = 1000 * 15
        ..options.receiveTimeout = 1000 * 15
        ..options.connectTimeout = 1000 * 10;

      try {
        ///不知道这玩意有没有上限
        final fromData = FormData()
          ..files.add(
            MapEntry(
              'file',
              MultipartFile.fromBytes(imageBytes, filename: 'img.jpg'),
            ),
          );
        final response = await httpClient.post(
          'https://saucenao.com/search.php',
          data: fromData,
        );

        final document = parse(response.data!);
        //<strong>Pixiv ID: </strong><a href="https://www.pixiv.net/member_illust.php?mode=medium&illust_id=76434553"
        final aTag = document.querySelectorAll('a');
        aTag.forEach((element) {
          final href = element.attributes['href'];
          if (href != null &&
              href.startsWith('https://www.pixiv.net/') &&
              href.contains('illust_id')) {
            final id = Uri.parse(href).queryParameters['illust_id'];
            if (id is String) {
              ids.add(int.parse(id));
            }
          }
        });
        Utils.toast('搜索到${ids.length}个插画');
      } on Exception catch (e) {
        Utils.toast('搜索图片失败');
        LogUtil.instance.add(
          type: LogType.NetworkException,
          id: 0,
          title: '在搜索图片页面',
          url: '',
          context: '网络异常',
          exception: e,
        );
      }
      httpClient.close();
    }

    return ids;
  }
}
