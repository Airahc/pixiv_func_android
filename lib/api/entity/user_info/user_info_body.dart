import 'package:json_annotation/json_annotation.dart';
import 'user_details.dart';

part 'user_info_body.g.dart';

@JsonSerializable(explicitToJson: true)
class UserInfoBody {
  @JsonKey(name: 'user_details')
  UserDetails userDetails;

  UserInfoBody(this.userDetails);

  factory UserInfoBody.fromJson(Map<String, dynamic> json) => _$BodyFromJson(json);

  Map<String, dynamic> toJson() => _$BodyToJson(this);


}
