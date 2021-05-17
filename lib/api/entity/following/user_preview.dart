import 'package:json_annotation/json_annotation.dart';
import 'illust.dart';

part 'user_preview.g.dart';

@JsonSerializable(explicitToJson: true)
class UserPreview{
  @JsonKey(name: 'userId')
  int userId;
  @JsonKey(name: 'userName')
  String userName;
  @JsonKey(name: 'profileImageUrl')
  String profileImageUrl;
  @JsonKey(name: 'userComment')
  String userComment;
  @JsonKey(name: 'following')
  bool following;
  @JsonKey(name: 'followed')
  bool followed;
  @JsonKey(name: 'isBlocking')
  bool isBlocking;
  @JsonKey(name: 'isMypixiv')
  bool isMyPixiv;
  @JsonKey(name: 'illusts')
  List<Illust> illusts;
  ///接受约稿?
  @JsonKey(name: 'acceptRequest')
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
