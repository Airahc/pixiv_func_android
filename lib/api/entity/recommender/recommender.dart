import 'package:json_annotation/json_annotation.dart';
import 'recommender_body.dart';

part 'recommender.g.dart';

@JsonSerializable(explicitToJson: true)
class Recommender{
  bool error;
  String message;
  RecommenderBody? body;

  Recommender(this.error, this.message, this.body);

  factory Recommender.fromJson(Map<String, dynamic> json) => _$RecommenderFromJson(json);

  Map<String, dynamic> toJson() => _$RecommenderToJson(this);
}
