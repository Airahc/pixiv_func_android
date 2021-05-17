import 'package:json_annotation/json_annotation.dart';
import 'user_works_body.dart';

part 'user_works.g.dart';

@JsonSerializable(explicitToJson: true)
class UserWorks{
  @JsonKey(name: 'error')
  bool error;
  @JsonKey(name: 'message')
  String message;
  @JsonKey(name: 'body')
  UserWorksBody? body;

  UserWorks(this.error, this.message, this.body);

  factory UserWorks.fromJson(Map<String, dynamic> json) =>
      _$UserWorksFromJson(json);

  Map<String, dynamic> toJson() => _$UserWorksToJson(this);
}
