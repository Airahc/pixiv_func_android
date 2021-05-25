import 'package:json_annotation/json_annotation.dart';

import 'illust_many_body.dart';
part 'illust_many.g.dart';
@JsonSerializable(explicitToJson: true)
class IllustMany{
  bool error;
  String message;
  IllustManyBody? body;

  IllustMany(this.error, this.message, this.body);

  factory IllustMany.fromJson(Map<String, dynamic> json) => _$IllustManyFromJson(json);

  Map<String, dynamic> toJson() => _$IllustManyToJson(this);

}
