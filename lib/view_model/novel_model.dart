/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:novel_model.dart
 * 创建时间:2021/10/3 上午8:57
 * 作者:小草
 */

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:pixiv_func_android/api/model/novel_js_data.dart';
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:html/parser.dart' as html show parse;
import 'package:html/dom.dart' as html;
import 'package:pixiv_func_android/provider/base_view_state_model.dart';

class NovelModel extends BaseViewStateModel {
  final int id;
  NovelJSData? novelJSData;

  NovelModel(this.id);

  NovelJSData decodeNovelHtml(html.Document document) {
    Map<String, dynamic>? json;
    final scriptTags = document.querySelectorAll('script');
    for (final scriptTag in scriptTags) {
      if (scriptTag.text.contains('Object.defineProperty(window, \'pixiv\'')) {
        //novel : { "id":"123123", ...... []}
        final jsonString = RegExp(r'({)(.*?)("id")(.*?)(]})').stringMatch(scriptTag.text);
        if (null != jsonString) {
          json = jsonDecode(jsonString);
        }

        break;
      }
    }

    return NovelJSData.fromJson(json!);
  }

  void loadData() {
    setBusy();
    pixivAPI.getNovelHtml(id).then((result) {
      novelJSData = decodeNovelHtml(html.parse(result));
      setIdle();
    }).catchError((e, s) {
      if (e is DioError && e.response?.statusCode == HttpStatus.notFound) {
        setEmpty();
      } else {
        setInitFailed(e, s);
      }
    });
  }
}
