import 'package:json_annotation/json_annotation.dart';

part 'illust.g.dart';

@JsonSerializable(explicitToJson: true)
class Illust{
  @JsonKey(name: 'id')
  int id;
  @JsonKey(name: 'title')
  String title;
  @JsonKey(name: 'illustType')
  int illustType;
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
  ///可收藏?
  @JsonKey(name: 'isBookmarkable')
  bool isBookmarkable;
  @JsonKey(name: 'alt')
  String alt;
  @JsonKey(name: 'createDate')
  String createDate;
  @JsonKey(name: 'updateDate')
  String updateDate;
  @JsonKey(name: 'isUnlisted')
  bool isUnlisted;
  @JsonKey(name: 'isMasked')
  bool isMasked;
  @JsonKey(name: 'profileImageUrl')
  String profileImageUrl;


  Illust(
      this.id,
      this.title,
      this.illustType,
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
      this.isUnlisted,
      this.isMasked,
      this.profileImageUrl);

  factory Illust.fromJson(Map<String, dynamic> json) => _$IllustFromJson(json);

  Map<String, dynamic> toJson() => _$IllustToJson(this);
}
