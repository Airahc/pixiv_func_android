import 'package:json_annotation/json_annotation.dart';

import 'author_details.dart';

part 'illust.g.dart';

@JsonSerializable(explicitToJson: true)
class Illust {
  @JsonKey(name: 'url')
  String? url;
  @JsonKey(name: 'tags')
  List<String> tags;
  @JsonKey(name: 'bookmark_id')
  int? bookmarkId;
  @JsonKey(name: 'alt')
  String alt;
  @JsonKey(name: 'url_s')
  String urlS;
  @JsonKey(name: 'url_sm')
  String urlSM;
  @JsonKey(name: 'url_w')
  String urlW;
  @JsonKey(name: 'url_ss')
  String? urlSS;
  @JsonKey(name: 'url_big')
  String? urlBig;
  @JsonKey(name: 'url_placeholder')
  String? urlPlaceholder;
  @JsonKey(name: 'upload_timestamp')
  int uploadTimestamp;
  @JsonKey(name: 'id')
  int id;
  @JsonKey(name: 'user_id')
  int userId;
  @JsonKey(name: 'title')
  String title;
  @JsonKey(name: 'width')
  int width;
  @JsonKey(name: 'height')
  int height;
  @JsonKey(name: 'page_count')
  String pageCount;
  @JsonKey(name: 'comment')
  String? comment;
  @JsonKey(name: 'author_details')
  AuthorDetails authorDetails;

  Illust(
      this.url,
      this.tags,
      this.bookmarkId,
      this.alt,
      this.urlS,
      this.urlSM,
      this.urlW,
      this.urlSS,
      this.urlBig,
      this.urlPlaceholder,
      this.uploadTimestamp,
      this.id,
      this.userId,
      this.title,
      this.width,
      this.height,
      this.pageCount,
      this.comment,
      this.authorDetails);

  factory Illust.fromJson(Map<String, dynamic> json) => _$IllustFromJson(json);

  Map<String, dynamic> toJson() => _$IllustToJson(this);
}
