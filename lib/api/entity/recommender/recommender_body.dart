import 'package:json_annotation/json_annotation.dart';
import 'recommender_methods.dart';

part 'recommender_body.g.dart';

@JsonSerializable(explicitToJson: true)
class RecommenderBody{
  @JsonKey(name: 'recommended_work_ids')
  List<int> recommendedWorkIds;
  Map<int,RecommenderMethod> methods;//string

  RecommenderBody(this.recommendedWorkIds, this.methods);

  factory RecommenderBody.fromJson(Map<String, dynamic> json) => _$RecommenderBodyFromJson(json);

  Map<String, dynamic> toJson() => _$RecommenderBodyToJson(this);
}
