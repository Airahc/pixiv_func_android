import 'package:json_annotation/json_annotation.dart';

part 'work.g.dart';

@JsonSerializable(explicitToJson: true)
class Work{
  int id;
  String title;
  String url;
  String description;
  List<String> tags;
  int userId;
  String userName;
  int width;
  int height;
  int pageCount;
  bool isBookmarkable;
  String alt;
  String createDate;
  String updateDate;
  String? profileImageUrl;
  bool isMasked;
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
      this.alt,
      this.createDate,
      this.updateDate,
      this.profileImageUrl,
      this.isMasked,
      );

  factory Work.fromJson(Map<String, dynamic> json) =>
      _$WorksFromJson(json);

  Map<String, dynamic> toJson() => _$WorksToJson(this);
}
