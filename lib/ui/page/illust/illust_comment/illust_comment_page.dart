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
    return [for (final commentTree in commentTrees) _buildCommentTile(context, model, commentTree)];
  }

  Widget _buildCommentContent(IllustCommentModel model, Comment comment) {
    final commentContent = <Widget>[const SizedBox(height: 5)];
    commentContent.addAll(
      [
        Text(
          comment.user.name,
        ),
        const SizedBox(height: 10),
      ],
    );
    if (null != comment.stamp) {
      commentContent.addAll(
        [
          Image.asset('assets/stamps/stamp-${comment.stamp!.stampId}.jpg'),
          const SizedBox(height: 10),
        ],
      );
    }
    if (comment.comment.isNotEmpty) {
      commentContent.addAll(
        [
          Text(comment.comment),
          const SizedBox(height: 10),
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
                      style: const TextStyle(color: Colors.white54),
                    ),
                    Expanded(child: Container()),
                    OutlinedButton(
                      onPressed: () => model.doDeleteComment(commentTree),
                      child: const Text('删除'),
                    )
                  ],
                )
              : Text(
                  Utils.japanDateToLocalDateString(DateTime.parse(commentTree.data.date)),
                  style: const TextStyle(color: Colors.white54),
                ),
          trailing: commentTree.loading
              ? const CircularProgressIndicator()
              : commentTree.data.hasReplies
                  ? OutlinedButton(
                      onPressed: () => model.loadFirstReplies(commentTree),
                      child: const Text('加载回复'),
                    )
                  : null,
        ),
      );
    } else {
      final children = _buildCommentTileList(context, model, commentTree.children);

      if (commentTree.loading) {
        children.add(
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
            child: Center(child: CircularProgressIndicator()),
          ),
        );
      } else if (commentTree.hasNext) {
        children.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
            child: Card(
              child: ListTile(
                onTap: () => model.loadNextReplies(commentTree),
                title: const Center(child: Text('点击加载更多')),
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
            childrenPadding: const EdgeInsets.only(left: 20),
            children: children,
            title: _buildCommentContent(model, commentTree.data),
            subtitle: accountManager.current?.user.id == commentTree.data.user.id.toString()
                ? Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        Utils.japanDateToLocalDateString(DateTime.parse(commentTree.data.date)),
                        style: const TextStyle(color: Colors.white54),
                      ),
                      Expanded(child: Container()),
                      OutlinedButton(
                        onPressed: () => model.doDeleteComment(commentTree),
                        child: const Text('删除'),
                      )
                    ],
                  )
                : Text(
                    Utils.japanDateToLocalDateString(DateTime.parse(commentTree.data.date)),
                    style: const TextStyle(color: Colors.white54),
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

        if (ViewState.empty != model.viewState) {
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
                  icon: const Icon(
                    Icons.reply_sharp,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: model.commentInput,
                    decoration: InputDecoration(
                      labelText: model.commentInputLabel,
                      prefix: const SizedBox(width: 5),
                      suffixIcon: InkWell(
                        onTap: () {
                          model.commentInput.clear();
                        },
                        child: const Icon(
                          Icons.close_sharp,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: ElevatedButton(
                    onPressed: model.doAddComment,
                    child: const Text('发送'),
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
        title: const Text('插画的评论'),
      ),
      body: _buildBody(),
    );
  }
}
