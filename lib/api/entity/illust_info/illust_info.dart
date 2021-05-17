import 'package:json_annotation/json_annotation.dart';
import 'illust_info_body.dart';

part 'illust_info.g.dart';

@JsonSerializable(explicitToJson: true)
class IllustInfo{
  @JsonKey(name: 'error')
  bool error;
  @JsonKey(name: 'message')
  String message;
  @JsonKey(name: 'body')
  IllustInfoBody? body;


  IllustInfo(this.error, this.message, this.body);

  factory IllustInfo.fromJson(Map<String, dynamic> json) => _$IllustInfoFromJson(json);

  Map<String, dynamic> toJson() => _$IllustInfoToJson(this);
}
