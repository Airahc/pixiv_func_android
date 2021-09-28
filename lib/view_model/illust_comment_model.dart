/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:illust_comment_model.dart
 * 创建时间:2021/8/28 下午6:25
 * 作者:小草
 */

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:pixiv_func_android/api/model/comments.dart';
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/log/log.dart';
import 'package:pixiv_func_android/model/comment_tree.dart';
import 'package:pixiv_func_android/provider/base_view_state_refresh_list_model.dart';

class IllustCommentModel extends BaseViewStateRefreshListModel<CommentTree> {
  final int illustId;

  IllustCommentModel(this.illustId);

  final TextEditingController commentInput = TextEditingController();

  @override
  void dispose(){
    commentInput.dispose();
    super.dispose();
  }


  CommentTree? _repliesCommentTree;

  CommentTree? get repliesCommentTree => _repliesCommentTree;


  set repliesCommentTree(CommentTree? value) {
    _repliesCommentTree = value;
    notifyListeners();
  }

  bool get isReplies => null != _repliesCommentTree;

  String get commentInputLabel => isReplies ? '回复 ${repliesCommentTree!.data.user.name}' : '评论 插画';

  @override
  Future<List<CommentTree>> loadFirstDataRoutine() async {
    final result = await pixivAPI.getIllustComments(illustId);
    nextUrl = result.nextUrl;

    return result.comments.map((e) => CommentTree(data: e, parent: null)).toList();
  }

  @override
  Future<List<CommentTree>> loadNextDataRoutine() async {
    final result = await pixivAPI.next<Comments>(nextUrl!);

    nextUrl = result.nextUrl;

    return result.comments.map((e) => CommentTree(data: e, parent: null)).toList();
  }

  void loadFirstReplies(CommentTree commentTree) {
    commentTree.loading = true;
    notifyListeners();
    if (commentTree.data.hasReplies) {
      pixivAPI.getCommentReplies(commentTree.data.id).then((result) {
        commentTree.children.addAll(result.comments.map((e) => CommentTree(data: e, parent: commentTree)));
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
        commentTree.children.addAll(result.comments.map((e) => CommentTree(data: e, parent: commentTree)));
        commentTree.nextUrl = result.nextUrl;
      }).catchError((e) {
        Log.e('加载下一条回复异常', e);
      }).whenComplete(() {
        commentTree.loading = false;
        notifyListeners();
      });
    }
  }

  void doAddComment() {
    final commentTree = repliesCommentTree;
    final content = commentInput.text;
    commentInput.clear();
    pixivAPI.addComment(illustId, comment: content, parentCommentId: commentTree?.data.id).then((result) {
      if (null != commentTree) {
        commentTree.children.insert(0, CommentTree(data: result, parent: commentTree));
        notifyListeners();
        platformAPI.toast('回复 ${commentTree.data.user.name} 成功');
      } else {
        list.insert(0, CommentTree(data: result, parent: null));
        notifyListeners();
        platformAPI.toast('评论 插画 成功');
      }
    }).catchError((e, s) {
      if (e is DioError && e.response?.statusCode == HttpStatus.notFound) {
        platformAPI.toast('评论失败,欲回复的评论不存在');
      } else {
        platformAPI.toast('评论失败,请重试');
      }
      Log.e('评论异常', e, s);
    });
  }

  void doDeleteComment(
    CommentTree commentTree,
  ) {
    pixivAPI.deleteComment(commentTree.data.id).then((value) {
      if (null == commentTree.parent) {
        list.removeWhere((element) => commentTree.data.id == element.data.id);
        notifyListeners();
      } else {
        commentTree.parent!.children.removeWhere((element) => commentTree.data.id == element.data.id);
        notifyListeners();
      }
      platformAPI.toast('删除评论成功');
    }).catchError((e) {
      Log.e('删除评论失败', e);
      platformAPI.toast('删除评论失败');
    });
  }
}
