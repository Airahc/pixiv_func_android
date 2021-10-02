/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:illust_content_model.dart
 * 创建时间:2021/8/26 下午8:32
 * 作者:小草
 */

import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:pixiv_func_android/api/entity/illust.dart';
import 'package:pixiv_func_android/api/model/illusts.dart';
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/log/log.dart';
import 'package:pixiv_func_android/provider/base_view_state_list_model.dart';
import 'package:pixiv_func_android/util/utils.dart';
import 'package:pixiv_func_android/view_model/illust_previewer_model.dart';

class IllustContentModel extends BaseViewStateListModel<Illust> {
  final Illust illust;
  final IllustPreviewerModel? _illustPreviewerModel;

  IllustContentModel(this.illust, {IllustPreviewerModel? illustPreviewerModel})
      : _illustPreviewerModel = illustPreviewerModel {
    if (settingsManager.enableBrowsingHistory) {
      browsingHistoryManager.exist(illust.id).then((exist) {
        if (!exist) {
          browsingHistoryManager.insert(illust);
        }
      });
    }
  }

  bool _showOriginalCaption = false;

  bool _bookmarkRequestWaiting = false;

  double _downloadProgress = 0.0;

  Uint8List? _gifBytes;

  bool _downloadingGif = false;

  bool _generatingGif = false;

  bool get isBookmarked => illust.isBookmarked;

  set isBookmarked(bool value) {
    illust.isBookmarked = value;
    _illustPreviewerModel?.isBookmarked = value;
    notifyListeners();
  }

  bool get isUgoira => 'ugoira' == illust.type;

  bool get showOriginalCaption => _showOriginalCaption;

  set showOriginalCaption(bool value) {
    _showOriginalCaption = value;
    notifyListeners();
  }

  bool get bookmarkRequestWaiting => _bookmarkRequestWaiting;

  set bookmarkRequestWaiting(bool value) {
    _bookmarkRequestWaiting = value;
    notifyListeners();
  }

  double get downloadProgress => _downloadProgress;

  set downloadProgress(double value) {
    _downloadProgress = value;
    notifyListeners();
  }

  Uint8List? get gifBytes => _gifBytes;

  set gifBytes(Uint8List? value) {
    _gifBytes = value;
    notifyListeners();
  }

  bool get downloadingGif => _downloadingGif;

  set downloadingGif(bool value) {
    _downloadingGif = value;
    notifyListeners();
  }

  bool get generatingGif => _generatingGif;

  set generatingGif(bool value) {
    _generatingGif = value;
    notifyListeners();
  }

  void loadFirstData() {
    setBusy();

    pixivAPI.getIllustRelated(illust.id).then((result) {
      if (result.illusts.isNotEmpty) {
        list.addAll(result.illusts);
        setIdle();
      } else {
        setEmpty();
      }

      nextUrl = result.nextUrl;
      initialized = true;
    }).catchError((e, s) {
      Log.e('首次加载数据异常', e);
      setInitFailed(e, s);
    });
  }

  void loadNextData() {
    setBusy();
    pixivAPI.next<Illusts>(nextUrl!).then((result) {
      list.addAll(result.illusts);
      nextUrl = result.nextUrl;
      setIdle();
    }).catchError((e) {
      Log.e('加载下一条数据异常', e);
      setLoadFailed();
    });
  }

  void changeBookmarkState() {
    bookmarkRequestWaiting = true;
    if (!illust.isBookmarked) {
      pixivAPI.bookmarkAdd(illust.id).then((result) {
        isBookmarked = true;
      }).catchError((e) {
        Log.e('添加书签失败', e);
      }).whenComplete(() => bookmarkRequestWaiting = false);
    } else {
      pixivAPI.bookmarkDelete(illust.id).then((result) {
        isBookmarked = false;
      }).catchError((e) {
        Log.e('删除书签失败', e);
      }).whenComplete(() => bookmarkRequestWaiting = false);
    }
  }

  void startGenerateGif() {
    //获取信息
    downloadingGif = true;
    pixivAPI.getUgoiraMetadata(illust.id).then((result) {
      final dio = Dio(
        BaseOptions(
          headers: {'Referer': 'https://app-api.pixiv.net/'},
          responseType: ResponseType.bytes,
          sendTimeout: 15000,
          receiveTimeout: 15000,
          connectTimeout: 15000,
        ),
      );
      final ugoiraMetadata = result.ugoiraMetadata;
      final url = Utils.replaceImageSource(ugoiraMetadata.zipUrls.medium);
      //开始下载
      dio.get<Uint8List>(url, onReceiveProgress: (count, total) => count / total).then((response) {
        platformAPI.toast('开始生成GIF,共${ugoiraMetadata.frames.length}帧,可能需要一些时间', isLong: true);
        final delays = Int32List.fromList(ugoiraMetadata.frames.map((e) => e.delay).toList());
        generatingGif = true;
        platformAPI
            .generateGif(id: illust.id, zipBytes: response.data!, delays: delays)
            .then((bytes) => gifBytes = bytes)
            .catchError((e) {
          Log.e('生成GIF失败', e);
          platformAPI.toast('生成GIF失败');
        }).whenComplete(() => generatingGif = false);
      }).catchError((e, s) {
        Log.e('获取动图压缩包失败', e, s);
        platformAPI.toast('获取动图压缩包失败');
      }).whenComplete(() => downloadingGif = false);
    }).catchError((e, s) {
      Log.e('获取动图信息失败', e, s);
      platformAPI.toast('获取动图信息失败');
      downloadingGif = false;
    });
  }

  Future<void> saveGifFile() async {
    final filename = '${illust.id}.gif';

    if (await platformAPI.imageIsExist(filename)) {
      platformAPI.toast('GIF图片已经存在');
    } else {
      final saveResult = await platformAPI.saveImage(gifBytes!, filename);
      if (null == saveResult) {
        platformAPI.toast('GIF图片已经存在');
        return;
      }
      if (saveResult) {
        platformAPI.toast('保存成功');
      } else {
        platformAPI.toast('保存失败');
      }
    }
  }
}
