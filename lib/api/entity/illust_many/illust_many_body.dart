import 'package:json_annotation/json_annotation.dart';

import 'illust.dart';
part 'illust_many_body.g.dart';
@JsonSerializable(explicitToJson: true)
class IllustManyBody{

  @JsonKey(name: 'illust_details')
  List<Illust> illustDetails;


  IllustManyBody(this.illustDetails);

  factory IllustManyBody.fromJson(Map<String, dynamic> json) => _$IllustManyBodyFromJson(json);

  Map<String, dynamic> toJson() => _$IllustManyBodyToJson(this);

}
