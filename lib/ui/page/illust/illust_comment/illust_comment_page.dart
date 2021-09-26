/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:illust_comment_page.dart
 * 创建时间:2021/8/28 下午6:19
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:pixiv_func_android/api/entity/comment.dart';
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/model/comment_tree.dart';
import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/provider/view_state.dart';
import 'package:pixiv_func_android/ui/page/user/user_page.dart';
import 'package:pixiv_func_android/ui/widget/avatar_view_from_url.dart';
import 'package:pixiv_func_android/ui/widget/refresher_widget.dart';
import 'package:pixiv_func_android/util/page_utils.dart';
import 'package:pixiv_func_android/util/utils.dart';
import 'package:pixiv_func_android/view_model/illust_comment_model.dart';

class IllustCommentPage extends StatelessWidget {
  final int id;

  const IllustCommentPage(this.id, {Key? key}) : super(key: key);

  List<Widget> _buildCommentTileList(BuildContext context, IllustCommentModel model, List<CommentTree> commentTrees) {
    return commentTrees.map((commentTree) => _buildCommentTile(context, model, commentTree)).toList();
  }

  Widget _buildCommentContent(IllustCommentModel model, Comment comment) {
    final commentContent = <Widget>[SizedBox(height: 5)];
    commentContent.addAll(
      [
        Text(
          comment.user.name,
        ),
        SizedBox(height: 10),
      ],
    );
    if (null != comment.stamp) {
      commentContent.addAll(
        [
          Image.asset('assets/stamps/stamp-${comment.stamp!.stampId}.jpg'),
          SizedBox(height: 10),
        ],
      );
    }
    if (comment.comment.isNotEmpty) {
      commentContent.addAll(
        [
          Text(comment.comment),
          SizedBox(height: 10),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: commentContent,
    );
  }

  Widget _buildCommentTile(BuildContext context, IllustCommentModel model, CommentTree commentTree) {
    if (commentTree.children.isEmpty) {
      return Card(
        child: ListTile(
          leading: GestureDetector(
            onTap: () => PageUtils.to(context, UserPage(commentTree.data.user.id)),
            child: Hero(
              tag: 'user:${commentTree.data.user.id}',
              child: AvatarViewFromUrl(commentTree.data.user.profileImageUrls.medium),
            ),
          ),
          onLongPress: () => model.repliesCommentTree = commentTree,
          title: _buildCommentContent(model, commentTree.data),
          subtitle: accountManager.current?.user.id == commentTree.data.user.id.toString()
              ? Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      Utils.japanDateToLocalDateString(DateTime.parse(commentTree.data.date)),
                      style: TextStyle(color: Colors.white54),
                    ),
                    Expanded(child: Container()),
                    OutlinedButton(
                      onPressed: () => model.doDeleteComment(commentTree),
                      child: Text('删除'),
                    )
                  ],
                )
              : Text(
                  Utils.japanDateToLocalDateString(DateTime.parse(commentTree.data.date)),
                  style: TextStyle(color: Colors.white54),
                ),
          trailing: commentTree.loading
              ? CircularProgressIndicator()
              : commentTree.data.hasReplies
                  ? OutlinedButton(
                      onPressed: () => model.loadFirstReplies(commentTree),
                      child: Text('加载回复'),
                    )
                  : null,
        ),
      );
    } else {
      final children = _buildCommentTileList(context, model, commentTree.children);

      if (commentTree.loading) {
        children.add(
          Container(
            padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
            child: Center(child: CircularProgressIndicator()),
          ),
        );
      } else if (commentTree.hasNext) {
        children.add(
          Container(
            padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
            child: Card(
              child: ListTile(
                onTap: () => model.loadNextReplies(commentTree),
                title: Center(child: Text('点击加载更多')),
              ),
            ),
          ),
        );
      }

      return Card(
        child: InkWell(
          onLongPress: () => model.repliesCommentTree = commentTree,
          child: ExpansionTile(
            leading: GestureDetector(
              onTap: () => PageUtils.to(context, UserPage(commentTree.data.user.id)),
              child: Hero(
                tag: 'user:${commentTree.data.user.id}',
                child: AvatarViewFromUrl(commentTree.data.user.profileImageUrls.medium),
              ),
            ),
            childrenPadding: EdgeInsets.only(left: 20),
            children: children,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Text(
                  commentTree.data.user.name,
                ),
                SizedBox(height: 10),
                Text(commentTree.data.comment),
                SizedBox(height: 10),
              ],
            ),
            subtitle: accountManager.current?.user.id == commentTree.data.user.id.toString()
                ? Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        Utils.japanDateToLocalDateString(DateTime.parse(commentTree.data.date)),
                        style: TextStyle(color: Colors.white54),
                      ),
                      Expanded(child: Container()),
                      OutlinedButton(
                        onPressed: () => model.doDeleteComment(commentTree),
                        child: Text('删除'),
                      )
                    ],
                  )
                : Text(
                    Utils.japanDateToLocalDateString(DateTime.parse(commentTree.data.date)),
                    style: TextStyle(color: Colors.white54),
                  ),
          ),
        ),
      );
    }
  }

  Widget _buildBody() {
    return ProviderWidget(
      model: IllustCommentModel(id),
      builder: (BuildContext context, IllustCommentModel model, Widget? child) {
        final List<Widget> slivers = [];

        if (ViewState.Empty != model.viewState) {
          slivers.add(
            SliverList(
              delegate: SliverChildListDelegate(_buildCommentTileList(context, model, model.list)),
            ),
          );
        }

        return Column(
          children: [
            Flexible(
              child: RefresherWidget(
                model,
                child: CustomScrollView(
                  slivers: slivers,
                ),
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () => model.repliesCommentTree = null,
                  icon: Icon(
                    Icons.reply_sharp,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: model.commentInput,
                    decoration: InputDecoration(
                      labelText: model.commentInputLabel,
                      prefix: SizedBox(width: 5),
                      suffixIcon: InkWell(
                        onTap: () {
                          model.commentInput.clear();
                        },
                        child: Icon(
                          Icons.close_sharp,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 5),
                  child: ElevatedButton(
                    onPressed: model.doAddComment,
                    child: Text('发送'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('插画的评论'),
      ),
      body: _buildBody(),
    );
  }
}
