import 'package:json_annotation/json_annotation.dart';
import 'user.dart';

part 'search_users_body.g.dart';
@JsonSerializable(explicitToJson: true)
class SearchUsersBody{
  List<User> users;
  int total;
  int lastPage;

  SearchUsersBody(this.users, this.total, this.lastPage);

  factory SearchUsersBody.fromJson(Map<String, dynamic> json) =>
      _$SearchUsersBodyFromJson(json);

  Map<String, dynamic> toJson() => _$SearchUsersBodyToJson(this);

}
