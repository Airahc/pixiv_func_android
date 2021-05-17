import 'package:json_annotation/json_annotation.dart';

part 'illust_image.g.dart';

@JsonSerializable(explicitToJson: true)
class IllustImage{
  @JsonKey(name: 'illust_image_width')
  int illustImageWidth;
  @JsonKey(name: 'illust_image_height')
  int illustImageHeight;


  IllustImage(this.illustImageWidth, this.illustImageHeight);

  factory IllustImage.fromJson(Map<String, dynamic> json) => _$IllustImageFromJson(json);

  Map<String, dynamic> toJson() => _$IllustImageToJson(this);
}
