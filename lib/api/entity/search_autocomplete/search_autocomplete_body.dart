import 'package:json_annotation/json_annotation.dart';
import 'candidate.dart';

part 'search_autocomplete_body.g.dart';
@JsonSerializable(explicitToJson: true)
class SearchAutocompleteBody{
  List<Candidate> candidates;

  SearchAutocompleteBody(this.candidates);
  factory SearchAutocompleteBody.fromJson(Map<String, dynamic> json) => _$SearchAutocompleteBodyFromJson(json);

  Map<String, dynamic> toJson() => _$SearchAutocompleteBodyToJson(this);
}
