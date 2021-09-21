/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:user_details.dart
 * 创建时间:2021/8/21 上午9:38
 * 作者:小草
 */

import 'package:json_annotation/json_annotation.dart';
import '../entity/profile_image_urls.dart';

part 'user_detail.g.dart';

@JsonSerializable(explicitToJson: true)
class UserDetail{
  UserInfo user;
  UserProfile profile;
  @JsonKey(name: 'profile_publicity')
  UserProfilePublicity profilePublicity;
  UserWorkspace workspace;

  UserDetail(this.user, this.profile, this.profilePublicity, this.workspace);
  factory UserDetail.fromJson(Map<String, dynamic> json) =>
      _$UserDetailFromJson(json);

  Map<String, dynamic> toJson() => _$UserDetailToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UserInfo {
  int id;
  String name;
  String account;
  @JsonKey(name: 'profile_image_urls')
  ProfileImageUrls profileImageUrls;
  String? comment;
  @JsonKey(name: 'is_followed')
  bool isFollowed;

  UserInfo(
    this.id,
    this.name,
    this.account,
    this.profileImageUrls,
    this.comment,
    this.isFollowed,
  );
  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UserProfile {
  String? webpage;
  String gender;

  ///出生
  String birth;
  @JsonKey(name: 'birth_day')
  String birthDay;
  @JsonKey(name: 'birth_year')
  int birthYear;
  String region;
  @JsonKey(name: 'address_id')
  int addressId;
  @JsonKey(name: 'country_code')
  String countryCode;
  String job;
  @JsonKey(name: 'job_id')
  int jobId;
  @JsonKey(name: 'total_follow_users')
  int totalFollowUsers;
  @JsonKey(name: 'total_mypixiv_users')
  int totalMyPixivUsers;
  @JsonKey(name: 'total_illusts')
  int totalIllusts;

  @JsonKey(name: 'total_manga')
  int totalManga;
  @JsonKey(name: 'total_novels')
  int totalNovels;
  @JsonKey(name: 'total_illust_bookmarks_public')
  int totalIllustBookmarksPublic;
  @JsonKey(name: 'total_illust_series')
  int totalIllustSeries;
  @JsonKey(name: 'total_novel_series')
  int totalNovelSeries;
  @JsonKey(name: 'background_image_url')
  String? backgroundImageUrl;
  @JsonKey(name: 'twitter_account')
  String? twitterAccount;
  @JsonKey(name: 'twitter_url')
  String? twitterUrl;
  @JsonKey(name: 'pawoo_url')
  String? pawooUrl;
  @JsonKey(name: 'is_premium')
  bool isPremium;
  @JsonKey(name: 'is_using_custom_profile_image')
  bool isUsingCustomProfileImage;

  UserProfile(
    this.webpage,
    this.gender,
    this.birth,
    this.birthDay,
    this.birthYear,
    this.region,
    this.addressId,
    this.countryCode,
    this.job,
    this.jobId,
    this.totalFollowUsers,
    this.totalMyPixivUsers,
    this.totalIllusts,
    this.totalManga,
    this.totalNovels,
    this.totalIllustBookmarksPublic,
    this.totalIllustSeries,
    this.totalNovelSeries,
    this.backgroundImageUrl,
    this.twitterAccount,
    this.twitterUrl,
    this.pawooUrl,
    this.isPremium,
    this.isUsingCustomProfileImage,
  );
  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UserProfilePublicity {
  String gender;
  String region;
  @JsonKey(name: 'birth_day')
  String birthDay;
  @JsonKey(name: 'birth_year')
  String birthYear;
  String job;
  bool pawoo;

  UserProfilePublicity(
    this.gender,
    this.region,
    this.birthDay,
    this.birthYear,
    this.job,
    this.pawoo,
  );
  factory UserProfilePublicity.fromJson(Map<String, dynamic> json) =>
      _$UserProfilePublicityFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfilePublicityToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UserWorkspace {
  ///电脑
  String pc;

  ///显示器
  String monitor;

  ///软件
  String tool;

  ///扫描仪
  String scanner;

  ///数位板
  String tablet;

  ///鼠标
  String mouse;

  ///打印机
  String printer;

  ///桌子上的东西
  String desktop;

  ///画图时听的音乐
  String music;

  ///桌子
  String desk;

  ///椅子
  String chair;

  ///其他问题
  String comment;
  @JsonKey(name: 'workspace_image_url')
  String? workspaceImageUrl;

  UserWorkspace(
    this.pc,
    this.monitor,
    this.tool,
    this.scanner,
    this.tablet,
    this.mouse,
    this.printer,
    this.desktop,
    this.music,
    this.desk,
    this.chair,
    this.comment,
    this.workspaceImageUrl,
  );

  factory UserWorkspace.fromJson(Map<String, dynamic> json) =>
      _$UserWorkspaceFromJson(json);

  Map<String, dynamic> toJson() => _$UserWorkspaceToJson(this);
}
