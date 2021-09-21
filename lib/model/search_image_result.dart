/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:search_image_result.dart
 * 创建时间:2021/9/7 下午5:25
 * 作者:小草
 */

class SearchImageResult {
  ///相似度
  String similarityText;
  int illustId;

  SearchImageResult({required this.similarityText, required this.illustId});

  @override
  String toString() {
    return 'SearchImageResult{similarityText: $similarityText, illustId: $illustId}';
  }
}
