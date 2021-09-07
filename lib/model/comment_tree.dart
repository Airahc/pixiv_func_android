/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:comment_tree.dart
 * 创建时间:2021/8/28 下午6:21
 * 作者:小草
 */

import 'package:pixiv_func_android/api/entity/comment.dart';

class CommentTree {
  Comment data;
  List<CommentTree> children = [];
  bool loading = false;
  String? nextUrl;

  CommentTree(this.data);

  bool get hasNext => null != nextUrl;
}
