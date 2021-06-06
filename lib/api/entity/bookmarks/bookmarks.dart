import 'package:json_annotation/json_annotation.dart';
import 'bookmarks_body.dart';

part 'bookmarks.g.dart';

@JsonSerializable(explicitToJson: true)
class Bookmarks{

  bool error;

  @JsonKey(name:'message')
  String message;

  BookmarksBody? body;

  Bookmarks(this.error, this.message, this.body);

  factory Bookmarks.fromJson(Map<String, dynamic> json) => _$BookmarksFromJson(json);

  Map<String, dynamic> toJson() => _$BookmarksToJson(this);
}
