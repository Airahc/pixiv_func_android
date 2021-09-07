// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocalUser _$LocalUserFromJson(Map<String, dynamic> json) => LocalUser(
      LocalUserProfileImageUrls.fromJson(
          json['profile_image_urls'] as Map<String, dynamic>),
      json['id'] as String,
      json['name'] as String,
      json['account'] as String,
      json['mail_address'] as String,
      json['is_premium'] as bool,
      json['x_restrict'] as int,
      json['is_mail_authorized'] as bool,
      json['require_policy_agreement'] as bool,
    );

Map<String, dynamic> _$LocalUserToJson(LocalUser instance) => <String, dynamic>{
      'profile_image_urls': instance.profileImageUrls.toJson(),
      'id': instance.id,
      'name': instance.name,
      'account': instance.account,
      'mail_address': instance.mailAddress,
      'is_premium': instance.isPremium,
      'x_restrict': instance.xRestrict,
      'is_mail_authorized': instance.isMailAuthorized,
      'require_policy_agreement': instance.requirePolicyAgreement,
    };

LocalUserProfileImageUrls _$LocalUserProfileImageUrlsFromJson(
        Map<String, dynamic> json) =>
    LocalUserProfileImageUrls(
      json['px_16x16'] as String,
      json['px_50x50'] as String,
      json['px_170x170'] as String,
    );

Map<String, dynamic> _$LocalUserProfileImageUrlsToJson(
        LocalUserProfileImageUrls instance) =>
    <String, dynamic>{
      'px_16x16': instance.px16x16,
      'px_50x50': instance.px50x50,
      'px_170x170': instance.px170x170,
    };
