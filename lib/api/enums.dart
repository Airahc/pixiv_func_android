/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:enums.dart
 * 创建时间:2021/8/24 下午8:36
 * 作者:小草
 */

//Dart的enum 不能有具体值

enum RankingMode {
  ///天
  DAY,

  ///天 R18
  DAY_R18,

  ///天 男性欢迎
  DAY_MALE,

  ///天 男性欢迎 R18
  DAY_MALE_R18,

  ///天 女性欢迎
  DAY_FEMALE,

  ///天 女性欢迎 R18
  DAY_FEMALE_R18,

  ///周
  WEEK,

  ///周 R18
  WEEK_R18,

  ///周(原创)
  WEEK_ORIGINAL,

  ///周(新人)
  WEEK_ROOKIE,

  ///月
  MONTH,
}

enum WorkType {
  ///插画
  ILLUST,

  ///漫画
  MANGA,
}

enum SearchSort {
  ///时间降序(最新)
  DATE_DESC,

  ///时间升序(最旧)
  DATE_ASC,
}

enum SearchTarget {
  ///标签(部分匹配)
  PARTIAL_MATCH_FOR_TAGS,

  ///标签(完全匹配)
  EXACT_MATCH_FOR_TAGS,

  ///标签&简介
  TITLE_AND_CAPTION,
}
