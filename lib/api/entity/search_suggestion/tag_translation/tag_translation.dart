import 'package:json_annotation/json_annotation.dart';

part 'tag_translation.g.dart';

@JsonSerializable(explicitToJson: true)
class TagTranslation{
  String? en;
  String? ko;
  String? zh;
  @JsonKey(name:'zh_tw')
  String? zhTW;
  String? romaji;

  TagTranslation(this.en, this.ko, this.zh, this.zhTW, this.romaji);

  factory TagTranslation.fromJson(Map<String, dynamic> json) => _$TagTranslationFromJson(json);

  Map<String, dynamic> toJson() => _$TagTranslationToJson(this);
}
