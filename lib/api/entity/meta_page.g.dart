/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:meta_page.g.dart
 * 创建时间:2021/9/19 下午6:28
 * 作者:小草
 */

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meta_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetaPage _$MetaPageFromJson(Map<String, dynamic> json) => MetaPage(
      ImageUrls.fromJson(json['image_urls'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MetaPageToJson(MetaPage instance) => <String, dynamic>{
      'image_urls': instance.imageUrls.toJson(),
    };
