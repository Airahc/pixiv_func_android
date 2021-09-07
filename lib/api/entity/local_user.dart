/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:local_user.dart
 * 创建时间:2021/8/21 下午3:55
 * 作者:小草
 */

import 'package:json_annotation/json_annotation.dart';

part 'local_user.g.dart';

@JsonSerializable(explicitToJson: true)
class LocalUser {
  @JsonKey(name: 'profile_image_urls')
  LocalUserProfileImageUrls profileImageUrls;
  String id;
  String name;
  String account;
  @JsonKey(name: 'mail_address')
  String mailAddress;
  @JsonKey(name: 'is_premium')
  bool isPremium;
  @JsonKey(name: 'x_restrict')
  int xRestrict;
  @JsonKey(name: 'is_mail_authorized')
  bool isMailAuthorized;
  @JsonKey(name: 'require_policy_agreement')
  bool requirePolicyAgreement;

  LocalUser(
    this.profileImageUrls,
    this.id,
    this.name,
    this.account,
    this.mailAddress,
    this.isPremium,
    this.xRestrict,
    this.isMailAuthorized,
    this.requirePolicyAgreement,
  );



  factory LocalUser.fromJson(Map<String, dynamic> json) => _$LocalUserFromJson(json);

  Map<String, dynamic> toJson() => _$LocalUserToJson(this);
}

@JsonSerializable(explicitToJson: true)
class LocalUserProfileImageUrls {
  @JsonKey(name: 'px_16x16')
  String px16x16;
  @JsonKey(name: 'px_50x50')
  String px50x50;
  @JsonKey(name: 'px_170x170')
  String px170x170;

  LocalUserProfileImageUrls(this.px16x16, this.px50x50, this.px170x170);

  factory LocalUserProfileImageUrls.fromJson(Map<String, dynamic> json) =>
      _$LocalUserProfileImageUrlsFromJson(json);

  Map<String, dynamic> toJson() => _$LocalUserProfileImageUrlsToJson(this);
}
