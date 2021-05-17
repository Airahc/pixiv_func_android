import 'package:json_annotation/json_annotation.dart';

part 'display_tag.g.dart';

@JsonSerializable(explicitToJson: true)
class DisplayTag{
  String tag;
  @JsonKey(name: 'is_pixpedia_article_exists')
  bool isPixpediaArticleExists;
  ///翻译
  String? translation;
  @JsonKey(name: 'set_by_author')
  bool setByAuthor;
  @JsonKey(name: 'is_locked')
  bool isLocked;
  @JsonKey(name: 'is_deletable')
  bool isDeletable;


  DisplayTag(this.tag, this.isPixpediaArticleExists, this.translation,
      this.setByAuthor, this.isLocked, this.isDeletable);

  factory DisplayTag.fromJson(Map<String, dynamic> json) => _$DisplayTagFromJson(json);

  Map<String, dynamic> toJson() => _$DisplayTagToJson(this);
}
