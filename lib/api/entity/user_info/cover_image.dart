import 'package:json_annotation/json_annotation.dart';

part 'cover_image.g.dart';
@JsonSerializable(explicitToJson: true)
class CoverImage{
  //profile_cover_user_id string(数字)
  //profile_cover_is_private string(数字)
  //profile_cover_filename string
  @JsonKey(name: 'profile_cover_ext')
  String profileCoverExt;
  //profile_cover_upload_datetime string
  //profile_cover_sanity_level string(数字)
  @JsonKey(name: 'profile_cover_image')
  Map<String,String> profileCoverImage;

  CoverImage(this.profileCoverExt, this.profileCoverImage);

  factory CoverImage.fromJson(Map<String, dynamic> json) => _$CoverImageFromJson(json);

  Map<String, dynamic> toJson() => _$CoverImageToJson(this);
}
