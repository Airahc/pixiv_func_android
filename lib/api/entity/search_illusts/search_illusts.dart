import 'package:json_annotation/json_annotation.dart';
import 'search_illusts_body.dart';

part 'search_illusts.g.dart';

@JsonSerializable(explicitToJson: true)
class SearchIllusts{
  bool error;
  String message;
  SearchBody? body;

  SearchIllusts(this.error, this.message, this.body);

  factory SearchIllusts.fromJson(Map<String, dynamic> json) =>
      _$SearchFromJson(json);

  Map<String, dynamic> toJson() => _$SearchToJson(this);
}
