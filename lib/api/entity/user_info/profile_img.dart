import 'package:json_annotation/json_annotation.dart';

part 'profile_img.g.dart';
@JsonSerializable()
class ProfileImg{
  @JsonKey(name: 'main')
  String main;
  @JsonKey(name: 'main_s')
  String mainS;

  ProfileImg(this.main,this.mainS);

  factory ProfileImg.fromJson(Map<String, dynamic> json) => _$ProfileImgFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileImgToJson(this);
}
