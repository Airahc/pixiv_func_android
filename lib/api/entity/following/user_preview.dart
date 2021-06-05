import 'package:json_annotation/json_annotation.dart';
import 'illust.dart';

part 'user_preview.g.dart';

@JsonSerializable(explicitToJson: true)
class UserPreview{
  int userId;
  String userName;
  String profileImageUrl;
  String userComment;
  bool following;
  bool followed;
  bool isBlocking;
  @JsonKey(name: 'isMypixiv')
  bool isMyPixiv;
  List<Illust> illusts;
  ///接受约稿?
  late bool acceptRequest;

  UserPreview(
      this.userId,
      this.userName,
      this.profileImageUrl,
      this.userComment,
      this.following,
      this.followed,
      this.isBlocking,
      this.isMyPixiv,
      this.illusts,
      this.acceptRequest);



  factory UserPreview.fromJson(Map<String, dynamic> json) => _$UserPreviewFromJson(json);

  Map<String, dynamic> toJson() => _$UserPreviewToJson(this);
}
