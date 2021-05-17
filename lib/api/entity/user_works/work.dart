import 'package:json_annotation/json_annotation.dart';
import 'bookmark_data.dart';

part 'work.g.dart';

@JsonSerializable(explicitToJson: true)
class Work{
  @JsonKey(name: 'id')
  int id;
  @JsonKey(name: 'title')
  String title;
  @JsonKey(name: 'url')
  String url;
  @JsonKey(name: 'description')
  String description;
  @JsonKey(name: 'tags')
  List<String> tags;
  @JsonKey(name: 'userId')
  int userId;
  @JsonKey(name: 'userName')
  String userName;
  @JsonKey(name: 'width')
  int width;
  @JsonKey(name: 'height')
  int height;
  @JsonKey(name: 'pageCount')
  int pageCount;
  @JsonKey(name: 'isBookmarkable')
  bool isBookmarkable;
  @JsonKey(name: 'bookmarkData')
  BookmarkData? bookmarkData;
  @JsonKey(name: 'alt')
  String alt;
  @JsonKey(name: 'createDate')
  String createDate;
  @JsonKey(name: 'updateDate')
  String updateDate;


  Work(
      this.id,
      this.title,
      this.url,
      this.description,
      this.tags,
      this.userId,
      this.userName,
      this.width,
      this.height,
      this.pageCount,
      this.isBookmarkable,
      this.bookmarkData,
      this.alt,
      this.createDate,
      this.updateDate);

  factory Work.fromJson(Map<String, dynamic> json) =>
      _$WorksFromJson(json);

  Map<String, dynamic> toJson() => _$WorksToJson(this);
}
