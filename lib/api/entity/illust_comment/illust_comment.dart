import 'package:json_annotation/json_annotation.dart';
import 'illust_comment_body.dart';

part 'illust_comment.g.dart';

@JsonSerializable(explicitToJson: true)
class IllustComment{
  @JsonKey(name: 'error')
  bool error;
  @JsonKey(name: 'message')
  String message;
  @JsonKey(name: 'body')
  IllustCommentBody? body;


  IllustComment(this.error, this.message, this.body);

  factory IllustComment.fromJson(Map<String, dynamic> json) => _$IllustCommentFromJson(json);

  Map<String, dynamic> toJson() => _$IllustCommentToJson(this);
}
