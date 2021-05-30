import 'package:json_annotation/json_annotation.dart';
import 'cover_image.dart';
import 'profile_img.dart';

part 'user_details.g.dart';

@JsonSerializable(explicitToJson: true)
class UserDetails{
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
  @JsonKey(name: 'is_official')
  bool isOfficial;
  ///关注的数量
  @JsonKey(name: 'follows')
  int follows;
  ///社交账号
  @JsonKey(name: 'social')
  Map<String, Map<String, String>>? social;
  @JsonKey(name: 'user_comment_html')
  String userCommentHtml;
  @JsonKey(name: 'cover_image')
  late CoverImage? coverImage;


  UserDetails(
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
      this.isOfficial,
      this.follows,
      this.social,
      this.userCommentHtml,
      this.coverImage);

  factory UserDetails.fromJson(Map<String, dynamic> json) => _$UserDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$UserDetailsToJson(this);
}
