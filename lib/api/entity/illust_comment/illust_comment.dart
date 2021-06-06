import 'package:json_annotation/json_annotation.dart';
import 'illust_comment_body.dart';

part 'illust_comment.g.dart';

@JsonSerializable(explicitToJson: true)
class IllustComment{

  bool error;
  String message;
  IllustCommentBody? body;


  IllustComment(this.error, this.message, this.body);

  factory IllustComment.fromJson(Map<String, dynamic> json) => _$IllustCommentFromJson(json);

  Map<String, dynamic> toJson() => _$IllustCommentToJson(this);
}
