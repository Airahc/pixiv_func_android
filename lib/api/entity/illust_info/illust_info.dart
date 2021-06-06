import 'package:json_annotation/json_annotation.dart';
import 'illust_info_body.dart';

part 'illust_info.g.dart';

@JsonSerializable(explicitToJson: true)
class IllustInfo{

  bool error;
  String message;
  IllustInfoBody? body;


  IllustInfo(this.error, this.message, this.body);

  factory IllustInfo.fromJson(Map<String, dynamic> json) => _$IllustInfoFromJson(json);

  Map<String, dynamic> toJson() => _$IllustInfoToJson(this);
}
