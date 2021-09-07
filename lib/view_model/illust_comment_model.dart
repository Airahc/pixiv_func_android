/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:illust_comment_model.dart
 * 创建时间:2021/8/28 下午6:25
 * 作者:小草
 */

import 'package:pixiv_func_android/api/model/comments.dart';
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/log/log.dart';
import 'package:pixiv_func_android/model/comment_tree.dart';
import 'package:pixiv_func_android/provider/base_view_state_refresh_list_model.dart';

class IllustCommentModel extends BaseViewStateRefreshListModel<CommentTree> {
  final int illustId;

  IllustCommentModel(this.illustId);

  @override
  Future<List<CommentTree>> loadFirstDataRoutine() async {
    final result = await pixivAPI.getIllustComments(illustId);
    nextUrl = result.nextUrl;

    return result.comments.map((e) => CommentTree(e)).toList();
  }

  @override
  Future<List<CommentTree>> loadNextDataRoutine() async {
    final result = await pixivAPI.next<Comments>(nextUrl!);

    nextUrl = result.nextUrl;

    return result.comments.map((e) => CommentTree(e)).toList();
  }

  void loadFirstReplies(CommentTree commentTree) {
    commentTree.loading = true;
    notifyListeners();
    if (commentTree.data.hasReplies) {
      pixivAPI.getCommentReplies(commentTree.data.id).then((result) {
        commentTree.children.addAll(result.comments.map((e) => CommentTree(e)));
        commentTree.nextUrl = result.nextUrl;
      }).catchError((e) {
        Log.e('加载回复异常', e);
      }).whenComplete(() {
        commentTree.loading = false;
        notifyListeners();
      });
    }
  }

  void loadNextReplies(CommentTree commentTree) {
    if (commentTree.hasNext) {
      commentTree.loading = true;
      notifyListeners();
      pixivAPI.next<Comments>(commentTree.nextUrl!).then((result) {
        commentTree.children.addAll(result.comments.map((e) => CommentTree(e)));
        commentTree.nextUrl = result.nextUrl;
      }).catchError((e) {
        Log.e('加载下一条回复异常', e);
      }).whenComplete(() {
        commentTree.loading = false;
        notifyListeners();
      });
    }
  }
}
