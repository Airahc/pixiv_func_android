// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDetail _$UserDetailFromJson(Map<String, dynamic> json) => UserDetail(
      UserInfo.fromJson(json['user'] as Map<String, dynamic>),
      UserProfile.fromJson(json['profile'] as Map<String, dynamic>),
      UserProfilePublicity.fromJson(
          json['profile_publicity'] as Map<String, dynamic>),
      UserWorkspace.fromJson(json['workspace'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserDetailToJson(UserDetail instance) =>
    <String, dynamic>{
      'user': instance.user.toJson(),
      'profile': instance.profile.toJson(),
      'profile_publicity': instance.profilePublicity.toJson(),
      'workspace': instance.workspace.toJson(),
    };

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => UserInfo(
      json['id'] as int,
      json['name'] as String,
      json['account'] as String,
      ProfileImageUrls.fromJson(
          json['profile_image_urls'] as Map<String, dynamic>),
      json['comment'] as String?,
      json['is_followed'] as bool,
    );

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'account': instance.account,
      'profile_image_urls': instance.profileImageUrls.toJson(),
      'comment': instance.comment,
      'is_followed': instance.isFollowed,
    };

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
      json['webpage'] as String?,
      json['gender'] as String,
      json['birth'] as String,
      json['birth_day'] as String,
      json['birth_year'] as int,
      json['region'] as String,
      json['address_id'] as int,
      json['country_code'] as String,
      json['job'] as String,
      json['job_id'] as int,
      json['total_follow_users'] as int,
      json['total_mypixiv_users'] as int,
      json['total_illusts'] as int,
      json['total_manga'] as int,
      json['total_novels'] as int,
      json['total_illust_bookmarks_public'] as int,
      json['total_illust_series'] as int,
      json['total_novel_series'] as int,
      json['background_image_url'] as String?,
      json['twitter_account'] as String?,
      json['twitter_url'] as String?,
      json['pawoo_url'] as String?,
      json['is_premium'] as bool,
      json['is_using_custom_profile_image'] as bool,
    );

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'webpage': instance.webpage,
      'gender': instance.gender,
      'birth': instance.birth,
      'birth_day': instance.birthDay,
      'birth_year': instance.birthYear,
      'region': instance.region,
      'address_id': instance.addressId,
      'country_code': instance.countryCode,
      'job': instance.job,
      'job_id': instance.jobId,
      'total_follow_users': instance.totalFollowUsers,
      'total_mypixiv_users': instance.totalMyPixivUsers,
      'total_illusts': instance.totalIllusts,
      'total_manga': instance.totalManga,
      'total_novels': instance.totalNovels,
      'total_illust_bookmarks_public': instance.totalIllustBookmarksPublic,
      'total_illust_series': instance.totalIllustSeries,
      'total_novel_series': instance.totalNovelSeries,
      'background_image_url': instance.backgroundImageUrl,
      'twitter_account': instance.twitterAccount,
      'twitter_url': instance.twitterUrl,
      'pawoo_url': instance.pawooUrl,
      'is_premium': instance.isPremium,
      'is_using_custom_profile_image': instance.isUsingCustomProfileImage,
    };

UserProfilePublicity _$UserProfilePublicityFromJson(
        Map<String, dynamic> json) =>
    UserProfilePublicity(
      json['gender'] as String,
      json['region'] as String,
      json['birth_day'] as String,
      json['birth_year'] as String,
      json['job'] as String,
      json['pawoo'] as bool,
    );

Map<String, dynamic> _$UserProfilePublicityToJson(
        UserProfilePublicity instance) =>
    <String, dynamic>{
      'gender': instance.gender,
      'region': instance.region,
      'birth_day': instance.birthDay,
      'birth_year': instance.birthYear,
      'job': instance.job,
      'pawoo': instance.pawoo,
    };

UserWorkspace _$UserWorkspaceFromJson(Map<String, dynamic> json) =>
    UserWorkspace(
      json['pc'] as String,
      json['monitor'] as String,
      json['tool'] as String,
      json['scanner'] as String,
      json['tablet'] as String,
      json['mouse'] as String,
      json['printer'] as String,
      json['desktop'] as String,
      json['music'] as String,
      json['desk'] as String,
      json['chair'] as String,
      json['comment'] as String,
      json['workspace_image_url'] as String?,
    );

Map<String, dynamic> _$UserWorkspaceToJson(UserWorkspace instance) =>
    <String, dynamic>{
      'pc': instance.pc,
      'monitor': instance.monitor,
      'tool': instance.tool,
      'scanner': instance.scanner,
      'tablet': instance.tablet,
      'mouse': instance.mouse,
      'printer': instance.printer,
      'desktop': instance.desktop,
      'music': instance.music,
      'desk': instance.desk,
      'chair': instance.chair,
      'comment': instance.comment,
      'workspace_image_url': instance.workspaceImageUrl,
    };
