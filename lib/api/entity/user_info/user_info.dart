import 'package:json_annotation/json_annotation.dart';
import 'user_info_body.dart';

part 'user_info.g.dart';

@JsonSerializable(explicitToJson: true)
class UserInfo {
  bool error;
  String message;
  UserInfoBody? body;

  UserInfo(this.error, this.message, this.body);

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}
