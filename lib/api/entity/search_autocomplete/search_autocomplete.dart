import 'package:json_annotation/json_annotation.dart';

import 'search_autocomplete_body.dart';

part 'search_autocomplete.g.dart';

@JsonSerializable(explicitToJson: true)
class SearchAutocomplete {
  bool error;
  String message;
  SearchAutocompleteBody? body;

  SearchAutocomplete(this.error, this.message, this.body);

  factory SearchAutocomplete.fromJson(Map<String, dynamic> json) =>
      _$SearchAutocompleteFromJson(json);

  Map<String, dynamic> toJson() => _$SearchAutocompleteToJson(this);
}
