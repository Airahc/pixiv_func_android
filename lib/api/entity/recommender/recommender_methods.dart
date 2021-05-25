import 'package:json_annotation/json_annotation.dart';

part 'recommender_methods.g.dart';

@JsonSerializable(explicitToJson: true)
class RecommenderMethod{
  List<String> methods;
  double score;
  @JsonKey(name: 'seed_illust_ids')
  List<int> seedIllustIds;

  RecommenderMethod(this.methods, this.score, this.seedIllustIds); //string

  factory RecommenderMethod.fromJson(Map<String, dynamic> json) => _$RecommenderMethodFromJson(json);

  Map<String, dynamic> toJson() => _$RecommenderMethodToJson(this);

}
