import 'package:json_annotation/json_annotation.dart';
import 'illust.dart';
import 'profile_img.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User{
  @JsonKey(name: 'user_id')
  int userId;
  @JsonKey(name: 'user_status')
  int userStatus;
  @JsonKey(name: 'user_account')
  String userAccount;
  @JsonKey(name: 'user_name')
  String userName;
  @JsonKey(name: 'user_premium')
  String userPremium;
  @JsonKey(name: 'user_webpage')
  ///网站
  String userWebpage;
  ///国家
  @JsonKey(name: 'user_country')
  String? userCountry;
  ///出生日期
  @JsonKey(name: 'user_birth')
  String? userBirth;
  @JsonKey(name: 'user_comment')
  String userComment;
  @JsonKey(name: 'profile_img')
  ProfileImg profileImg;
  ///地区
  @JsonKey(name: 'location')
  String? location;
  ///工作
  @JsonKey(name: 'user_job_txt')
  String? userJobTxt;
  ///性别
  @JsonKey(name: 'user_sex_txt')
  String? userSexTxt;
  ///年龄
  @JsonKey(name: 'user_age')
  int? userAge;
  ///生日
  @JsonKey(name: 'user_birth_txt')
  String? userBirthTxt;
  @JsonKey(name: 'is_followed')
  bool isFollowed;
  @JsonKey(name: 'is_following')
  bool isFollowing;
  @JsonKey(name: 'is_mypixiv')
  bool isMyPixiv;
  @JsonKey(name: 'is_blocked')
  bool isBlocked;
  @JsonKey(name: 'is_blocking')
  bool isBlocking;
  @JsonKey(name: 'accept_request')
  bool acceptRequest;
  List<Illust> illusts;

  User(
      this.userId,
      this.userStatus,
      this.userAccount,
      this.userName,
      this.userPremium,
      this.userWebpage,
      this.userCountry,
      this.userBirth,
      this.userComment,
      this.profileImg,
      this.location,
      this.userJobTxt,
      this.userSexTxt,
      this.userAge,
      this.userBirthTxt,
      this.isFollowed,
      this.isFollowing,
      this.isMyPixiv,
      this.isBlocked,
      this.isBlocking,
      this.acceptRequest,
      this.illusts);

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
