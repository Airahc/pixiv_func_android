import 'package:json_annotation/json_annotation.dart';
import 'following_body.dart';

part 'following.g.dart';

@JsonSerializable(explicitToJson: true)
class Following{
  @JsonKey(name: 'error')
  bool error;
  @JsonKey(name: 'message')
  String message;
  @JsonKey(name: 'body')
  FollowingBody? body;


  Following(this.error, this.message, this.body);

  factory Following.fromJson(Map<String, dynamic> json) => _$FollowingFromJson(json);

  Map<String, dynamic> toJson() => _$FollowingToJson(this);
}
