import 'package:json_annotation/json_annotation.dart';
import 'search_users_body.dart';

part 'search_users.g.dart';
@JsonSerializable(explicitToJson: true)
class SearchUsers{
  bool error;
  String message;
  SearchUsersBody? body;

  SearchUsers(this.error, this.message, this.body);

  factory SearchUsers.fromJson(Map<String, dynamic> json) =>
      _$SearchUsersFromJson(json);

  Map<String, dynamic> toJson() => _$SearchUsersToJson(this);
}
