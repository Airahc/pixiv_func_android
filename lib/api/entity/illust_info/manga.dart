import 'package:json_annotation/json_annotation.dart';

part 'manga.g.dart';

@JsonSerializable(explicitToJson: true)
class Manga{
  int page;
  String url;
  @JsonKey(name: 'url_small')
  String urlSmall;
  @JsonKey(name: 'url_big')
  String urlBig;


  Manga(this.page, this.url, this.urlSmall, this.urlBig);

  factory Manga.fromJson(Map<String, dynamic> json) => _$MangaFromJson(json);

  Map<String, dynamic> toJson() => _$MangaToJson(this);
}
