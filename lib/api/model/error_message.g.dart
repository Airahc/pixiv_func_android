// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorMessage _$ErrorMessageFromJson(Map<String, dynamic> json) => ErrorMessage(
      error: Error.fromJson(json['error'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ErrorMessageToJson(ErrorMessage instance) =>
    <String, dynamic>{
      'error': instance.error.toJson(),
    };

Error _$ErrorFromJson(Map<String, dynamic> json) => Error(
      json['user_message'] as String?,
      json['message'] as String?,
      json['reason'] as String?,
      json['user_message_details'],
    );

Map<String, dynamic> _$ErrorToJson(Error instance) => <String, dynamic>{
      'user_message': instance.userMessage,
      'message': instance.message,
      'reason': instance.reason,
      'user_message_details': instance.userMessageDetails,
    };
