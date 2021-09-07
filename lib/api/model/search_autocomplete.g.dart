// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_autocomplete.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchAutocomplete _$SearchAutocompleteFromJson(Map<String, dynamic> json) =>
    SearchAutocomplete(
      (json['tags'] as List<dynamic>)
          .map((e) => Tag.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SearchAutocompleteToJson(SearchAutocomplete instance) =>
    <String, dynamic>{
      'tags': instance.tags.map((e) => e.toJson()).toList(),
    };
