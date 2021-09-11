/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_android
 * 文件名称:search_input_model.dart
 * 创建时间:2021/9/3 下午4:15
 * 作者:小草
 */

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pixiv_func_android/api/model/search_autocomplete.dart';
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/log/log.dart';
import 'package:pixiv_func_android/model/search_filter.dart';
import 'package:pixiv_func_android/model/search_image_result.dart';
import 'package:pixiv_func_android/provider/base_view_model.dart';
import 'package:async/async.dart';
import 'package:html/parser.dart' as html show parse;
import 'package:html/dom.dart' as html;

class SearchInputModel extends BaseViewModel {
  SearchAutocomplete? _searchAutocomplete;
  TextEditingController wordInput = TextEditingController();

  SearchFilter filter = SearchFilter.create();

  SearchAutocomplete? get searchAutocomplete => _searchAutocomplete;

  set searchAutocomplete(SearchAutocomplete? value) {
    _searchAutocomplete = value;
    notifyListeners();
  }

  bool get inputIsNumber => null != int.tryParse(wordInput.text);

  int get inputAsNumber => int.parse(wordInput.text);

  String get inputAsString => wordInput.text;

  DateTime _lastInputTime = DateTime.now();

  DateTime get lastInputTime => _lastInputTime;

  set lastInputTime(DateTime value) {
    _lastInputTime = value;
    notifyListeners();
  }

  CancelableOperation<SearchAutocomplete>? _cancelableTask;

  bool _searchImageWaiting = false;

  bool get searchImageWaiting => _searchImageWaiting;

  set searchImageWaiting(bool value) {
    _searchImageWaiting = value;
    notifyListeners();
  }

  void startAutocomplete() {
    Future.delayed(Duration(seconds: 1), () {
      if (DateTime.now().difference(lastInputTime) > Duration(seconds: 1)) {
        loadAutocomplete();
      }
    });
  }

  void loadAutocomplete() {
    cancelTask();
    searchAutocomplete = null;
    _cancelableTask = CancelableOperation.fromFuture(pixivAPI.searchAutocomplete(inputAsString));

    _cancelableTask?.value.then((result) {
      searchAutocomplete = result;
    }).catchError((e, s) {
      if (e is DioError) {
        Log.e(e.response);
      }
      Log.e('关键字自动补全失败', e, s);
    });
  }

  void cancelTask() {
    _cancelableTask?.cancel();
  }

  List<SearchImageResult> decodeSearchHtml(html.Document document) {
    final list = <SearchImageResult>[];
    //td标签
    final contents = document.querySelectorAll('.resulttablecontent');
    contents.forEach((td) {
      //一个div
      final similarityDiv = td.querySelector('.resultsimilarityinfo');

      //a标签
      final links = td.querySelectorAll('.linkify');

      final illustLinkIndex = links.indexWhere((a) {
        final href = a.attributes['href'];
        return (href != null && href.startsWith('https://www.pixiv.net/') && href.contains('illust_id'));
      });

      if (-1 != illustLinkIndex) {
        final illustHref = links[illustLinkIndex].attributes['href'];
        if (null != illustHref && null != similarityDiv) {
          final illustId = int.tryParse(Uri.parse(illustHref).queryParameters['illust_id'] ?? '');
          final similarityText = similarityDiv.text;
          if (null != illustId && similarityText.isNotEmpty) {
            list.add(
              SearchImageResult(
                similarityText: similarityText,
                illustId: illustId,
              ),
            );
          }
        }
      }
    });

    return list;
  }

  Future<void> searchImage({
    required void Function(List<SearchImageResult> results) successCallback,
    required void Function(dynamic e) errorCallback,
  }) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      searchImageWaiting = true;
      final imageBytes = await pickedFile.readAsBytes();

      final fromData = FormData()
        ..files.add(
          MapEntry(
            'file',
            MultipartFile.fromBytes(imageBytes, filename: pickedFile.name),
          ),
        )
        ..fields.add(
          MapEntry(
            'dbs[]',
            //pixiv Images
            '5',
          ),
        );
      final httpClient = Dio();
      httpClient.post<String>('https://saucenao.com/search.php', data: fromData).then((response) {
        final document = html.parse(response.data!);
        successCallback(decodeSearchHtml(document));
      }).catchError((e) {
        errorCallback(e);
        Log.e('搜索图片失败', e);
      }).whenComplete(() => searchImageWaiting = false);
    }
  }
}
