/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : illust_comments.dart
 */

import 'package:flutter/material.dart';
import 'package:pixiv_xiaocao_android/api/entity/illust_comment/comment.dart';
import 'package:pixiv_xiaocao_android/api/pixiv_request.dart';
import 'package:pixiv_xiaocao_android/component/avatar_view_from_url.dart';
import 'package:pixiv_xiaocao_android/log/log_entity.dart';
import 'package:pixiv_xiaocao_android/log/log_util.dart';

class _CommentStruct {
  Comment data;
  int repliesPage = 1;
  bool loading = false;
  bool hasNext = true;
  List<_CommentStruct> children = <_CommentStruct>[];

  _CommentStruct({required this.data});
}

class IllustCommentsPage extends StatefulWidget {
  final int illustId;

  final String illustTitle;

  IllustCommentsPage(this.illustId, this.illustTitle);

  @override
  _IllustCommentsPageState createState() => _IllustCommentsPageState();
}

class _IllustCommentsPageState extends State<IllustCommentsPage> {
  List<_CommentStruct> _comments = <_CommentStruct>[];

  int _currentPage = 1;

  int _total = 0;

  bool _hasNext = true;

  bool _loading = false;
  bool _initialize = false;

  @override
  void initState() {
    _loadData(reload: false, init: true);
    super.initState();
  }

  Future _loadData({bool reload = true, bool init = false}) async {
    if (this.mounted) {
      setState(() {
        _loading = true;
        if (reload) {
          _comments.clear();
          _total = 0;
          _currentPage = 1;
          _hasNext = true;
        }
        if (init) {
          _initialize = false;
        }
      });
    } else {
      return;
    }

    final illustComments = await PixivRequest.instance.getIllustComments(
      widget.illustId,
      _currentPage,
      requestException: (e) {
        LogUtil.instance.add(
          type: LogType.NetworkException,
          id: widget.illustId,
          title: '获取评论失败',
          url: '',
          context: '在评论界面',
        );
      },
      decodeException: (e, response) {
        LogUtil.instance.add(
          type: LogType.DeserializationException,
          id: widget.illustId,
          title: '获取评论反序列化异常',
          url: '',
          context: response,
        );
      },
    );

    if (this.mounted) {
      if (illustComments != null) {
        if (!illustComments.error) {
          illustComments.body?.comments.forEach((item) {
            _comments.add(_CommentStruct(data: item));
          });

          _total = illustComments.body!.commentCount!;
          _hasNext = _total - (_currentPage * 20) > 0;
        } else {
          LogUtil.instance.add(
            type: LogType.Info,
            id: widget.illustId,
            title: '获取评论失败',
            url: '',
            context: 'error:${illustComments.message}',
          );
        }
      }
    } else {
      return;
    }

    if (this.mounted) {
      setState(() {
        if (init) {
          _initialize = true;
        }
        _loading = false;
      });
    }
  }

  Future _loadRepliesData(
      {required _CommentStruct commentStruct, required int page}) async {
    if (this.mounted) {
      setState(() {
        commentStruct.loading = true;
      });
    } else {
      return;
    }
    final commentReplies = await PixivRequest.instance.getCommentReplies(
      commentStruct.data.oneCommentId,
      page,
      requestException: (e) {
        LogUtil.instance.add(
          type: LogType.NetworkException,
          id: widget.illustId,
          title: '获取评论回复失败',
          url: '',
          context: '在评论页面',
          exception: e,
        );
      },
      decodeException: (e, response) {
        LogUtil.instance.add(
          type: LogType.DeserializationException,
          id: widget.illustId,
          title: '获取评论回复反序列化异常',
          url: '',
          context: response,
          exception: e,
        );
      },
    );
    if (this.mounted && commentReplies != null) {
      if (!commentReplies.error) {
        if (commentReplies.body != null) {
          setState(() {
            commentReplies.body!.comments.forEach((item) {
              if (commentStruct.data.oneCommentId == item.oneCommentRootId) {
                commentStruct.children.insert(0, _CommentStruct(data: item));
              }
            });
            commentStruct.hasNext = commentReplies.body!.comments.length -
                    (commentStruct.repliesPage * 20) >
                0;
          });
        }
      } else {
        LogUtil.instance.add(
          type: LogType.Info,
          id: widget.illustId,
          title: '获取评论回复失败',
          url: '',
          context: 'error:${commentReplies.message}',
        );
      }
    } else {
      return;
    }
    if (this.mounted) {
      setState(() {
        commentStruct.loading = false;
      });
    }
  }

  List<Widget> _buildCommentTiles(
    List<_CommentStruct> children, {
    _CommentStruct? comment,
  }) {
    final list = <Widget>[];

    if (children.isEmpty) {
      if (!_initialize) {
        if (_loading) {
          list.add(SizedBox(height: 20));
          list.add(Center(child: CircularProgressIndicator()));
          list.add(SizedBox(height: 20));
        } else {
          list.add(ListTile(title: Center(child: Text('暂无评论'))));
        }
      }
    } else {
      final decoration = BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 1,
            color: Colors.white70,
          ),
        ),
      );

      final childrenDecoration = BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 1,
            color: Colors.pink.shade300,
          ),
        ),
      );

      final titleStyle = TextStyle(color: Colors.white);

      final subTitleStyle = TextStyle(color: Colors.white54);

      children.forEach((child) {
        if (child.children.isEmpty) {
          list.add(Container(
            decoration: comment != null ? childrenDecoration : decoration,
            child: ListTile(
              leading: AvatarViewFromUrl(child.data.img),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  Text(
                    child.data.userName,
                    style: titleStyle,
                  ),
                  SizedBox(height: 10),
                  Text(
                    child.data.oneComment,
                    style: titleStyle,
                  ),
                  SizedBox(height: 10),
                ],
              ),
              subtitle: Text(
                child.data.oneCommentDate2,
                style: subTitleStyle,
              ),
              trailing: child.data.hasReplies
                  ? child.loading
                      ? CircularProgressIndicator()
                      : OutlinedButton(
                          onPressed: () {
                            _loadRepliesData(
                              commentStruct: child,
                              page: child.repliesPage,
                            );
                          },
                          child: Text('加载回复'),
                        )
                  : null,
            ),
          ));
        } else {
          list.add(
            Container(
              decoration: comment != null ? childrenDecoration : decoration,
              child: ExpansionTile(
                leading: AvatarViewFromUrl(child.data.img),
                childrenPadding: EdgeInsets.only(left: 20),
                children: _buildCommentTiles(child.children, comment: child),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Text(
                      child.data.userName,
                      style: titleStyle,
                    ),
                    SizedBox(height: 10),
                    Text(
                      child.data.oneComment,
                      style: titleStyle,
                    ),
                    SizedBox(height: 10),
                  ],
                ),
                subtitle: Text(
                  child.data.oneCommentDate2,
                  style: subTitleStyle,
                ),
              ),
            ),
          );
        }
      });

      if (comment != null) {
        if (comment.loading) {
          list.add(SizedBox(height: 10));
          list.add(Center(child: CircularProgressIndicator()));
          list.add(SizedBox(height: 10));
        } else {
          if (comment.hasNext) {
            list.add(
              Container(
                decoration: childrenDecoration,
                child: ListTile(
                  title: Center(
                    child: Text('加载更多'),
                  ),
                  onTap: () {
                    comment.repliesPage++;
                    _loadRepliesData(
                      commentStruct: comment,
                      page: comment.repliesPage,
                    );
                  },
                ),
              ),
            );
          }
        }
      } else {
        if (_loading) {
          list.add(SizedBox(height: 10));
          list.add(Center(child: CircularProgressIndicator()));
          list.add(SizedBox(height: 10));
        } else {
          if (_hasNext) {
            list.add(
              Container(
                decoration: decoration,
                child: ListTile(
                  title: Center(
                    child: Text('加载更多'),
                  ),
                  onTap: () {
                    _currentPage++;
                    _loadData(reload: false);
                  },
                ),
              ),
            );
          } else {
            list.add(ListTile(
              subtitle: Center(
                child: Text('没有啦'),
              ),
            ));
          }
        }
      }
    }
    return list;
  }

  // Widget _buildBody() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          title: Text('${widget.illustTitle}'),
          subtitle: Text('共$_total条'),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: Scrollbar(
          child: ListView(
            children: _buildCommentTiles(_comments),
          ),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
