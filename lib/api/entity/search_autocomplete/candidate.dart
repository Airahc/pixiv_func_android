import 'package:json_annotation/json_annotation.dart';

part 'candidate.g.dart';
@JsonSerializable(explicitToJson: true)
class Candidate{
  @JsonKey(name:'tag_name')
  String tagName;
  @JsonKey(name:'access_count')
  String accessCount;
  @JsonKey(name:'type')
  String type;

  Candidate(this.tagName, this.accessCount, this.type);
  factory Candidate.fromJson(Map<String, dynamic> json) => _$CandidateFromJson(json);

  Map<String, dynamic> toJson() => _$CandidateToJson(this);
}
