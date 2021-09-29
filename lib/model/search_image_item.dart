/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:search_image_item.dart
 * 创建时间:2021/9/29 下午7:07
 * 作者:小草
 */

import 'package:pixiv_func_android/api/entity/illust.dart';
import 'package:pixiv_func_android/model/search_image_result.dart';

class SearchImageItem {
  Illust? illust;
  SearchImageResult result;
  bool loading = false;
  bool loadFailed = false;

  SearchImageItem(this.result);
}
