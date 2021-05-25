import 'package:json_annotation/json_annotation.dart';

part 'bookmark_add.g.dart';

@JsonSerializable(explicitToJson: true)
class BookmarkAdd {
  bool error;
  String message;
  bool isSucceed;
  int? lastBookmarkId;
  int restrict;

  BookmarkAdd(
    this.error,
    this.message,
    this.isSucceed,
    this.lastBookmarkId,
    this.restrict,
  );

  factory BookmarkAdd.fromJson(Map<String, dynamic> json) => _$BookmarkAddFromJson(json);

  Map<String, dynamic> toJson() => _$BookmarkAddToJson(this);

}
