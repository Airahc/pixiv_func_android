import 'package:json_annotation/json_annotation.dart';

part 'bookmark_delete.g.dart';

@JsonSerializable(explicitToJson: true)
class BookmarkDelete{
  bool error;
  String message;
  bool isSucceed;

  BookmarkDelete(this.error, this.message, this.isSucceed);
  factory BookmarkDelete.fromJson(Map<String, dynamic> json) => _$BookmarkDeleteFromJson(json);

  Map<String, dynamic> toJson() => _$BookmarkDeleteToJson(this);
}
