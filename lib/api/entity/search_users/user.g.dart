// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    int.parse(json['user_id'] as String),
    int.parse(json['user_status'] as String),
    json['user_account'] as String,
    json['user_name'] as String,
    json['user_premium'] as String,
    json['user_webpage'] as String,
    json['user_country'] as String?,
    json['user_birth'] as String?,
    json['user_comment'] as String,
    ProfileImg.fromJson(json['profile_img'] as Map<String, dynamic>),
    json['location'] as String?,
    json['user_job_txt'] as String?,
    json['user_sex_txt'] as String?,
    json['user_age'] as int?,
    json['user_birth_txt'] as String?,
    json['is_followed'] as bool,
    json['is_following'] as bool,
    json['is_mypixiv'] as bool,
    json['is_blocked'] as bool,
    json['is_blocking'] as bool,
    json['accept_request'] as bool,
    (json['illusts'] as List<dynamic>)
        .map((e) => Illust.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'user_id': instance.userId,
      'user_status': instance.userStatus,
      'user_account': instance.userAccount,
      'user_name': instance.userName,
      'user_premium': instance.userPremium,
      'user_webpage': instance.userWebpage,
      'user_country': instance.userCountry,
      'user_birth': instance.userBirth,
      'user_comment': instance.userComment,
      'profile_img': instance.profileImg.toJson(),
      'location': instance.location,
      'user_job_txt': instance.userJobTxt,
      'user_sex_txt': instance.userSexTxt,
      'user_age': instance.userAge,
      'user_birth_txt': instance.userBirthTxt,
      'is_followed': instance.isFollowed,
      'is_following': instance.isFollowing,
      'is_mypixiv': instance.isMyPixiv,
      'is_blocked': instance.isBlocked,
      'is_blocking': instance.isBlocking,
      'accept_request': instance.acceptRequest,
      'illusts': instance.illusts.map((e) => e.toJson()).toList(),
    };
