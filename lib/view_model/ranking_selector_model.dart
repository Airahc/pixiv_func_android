/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:ranking_selector_model.dart
 * 创建时间:2021/9/1 下午6:23
 * 作者:小草
 */

import 'package:pixiv_func_android/api/enums.dart';
import 'package:pixiv_func_android/model/ranking_type_item.dart';
import 'package:pixiv_func_android/provider/base_view_model.dart';

class RankingSelectorModel extends BaseViewModel {
  final List<MapEntry<RankingTypeItem, bool>> typeItems = [
    MapEntry(RankingTypeItem(RankingMode.day, '每日'), false),
    MapEntry(RankingTypeItem(RankingMode.dayR18, '每日(R-18)'), false),
    MapEntry(RankingTypeItem(RankingMode.dayMale, '每日(男性欢迎)'), false),
    MapEntry(RankingTypeItem(RankingMode.dayMaleR18, '每日(男性欢迎 & R-18)'), false),
    MapEntry(RankingTypeItem(RankingMode.dayFemale, '每日(女性欢迎)'), false),
    MapEntry(RankingTypeItem(RankingMode.dayFemaleR18, '每日(女性欢迎 & R-18)'), false),
    MapEntry(RankingTypeItem(RankingMode.week, '每周'), false),
    MapEntry(RankingTypeItem(RankingMode.weekR18, '每周(R-18)'), false),
    MapEntry(RankingTypeItem(RankingMode.weekOriginal, '每周(原创)'), false),
    MapEntry(RankingTypeItem(RankingMode.weekRookie, '每周(新人)'), false),
    MapEntry(RankingTypeItem(RankingMode.month, '每月'), false),
  ];

  void onSelected(RankingTypeItem key, bool newValue) {
    for (int i = 0; i < typeItems.length; i++) {
      if (key == typeItems[i].key) {
        typeItems[i] = MapEntry(key, newValue);
      }
    }

    notifyListeners();
  }
}
