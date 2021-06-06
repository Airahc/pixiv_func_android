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
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
  final List<_CommentStruct> _comments = <_CommentStruct>[];

  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  int _currentPage = 1;

  int _total = 0;

  bool _hasNext = true;

  bool _initialize = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future _loadData(
      {void Function()? onSuccess, void Function()? onFail}) async {
    var isSuccess = false;
    final illustComments = await PixivRequest.instance.getIllustComments(
      widget.illustId,
      _currentPage,
      requestException: (e) {
        LogUtil.instance.add(
          type: LogType.NetworkException,
          id: widget.illustId,
          title: '获取评论失败',
          url: '',
          context: '在评论页面',
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
          _hasNext = _total - (_currentPage++ * 20) > 0;

          isSuccess = true;
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
    }
    if (isSuccess) {
      onSuccess?.call();
    } else {
      onFail?.call();
    }
  }

  Future _loadRepliesData({required _CommentStruct commentStruct}) async {
    if (this.mounted) {
      setState(() {
        commentStruct.loading = true;
      });
    } else {
      return;
    }

    final commentReplies = await PixivRequest.instance.getCommentReplies(
      commentStruct.data.oneCommentId,
      commentStruct.repliesPage,
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
                    (commentStruct.repliesPage++ * 20) >
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

    if (children.isNotEmpty) {
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
                    _loadRepliesData(
                      commentStruct: comment,
                    );
                  },
                ),
              ),
            );
          }
        }
      }
    }
    return list;
  }

  Widget _buildBody() {
    return Container(
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: _buildCommentTiles(_comments),
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    setState(() {
      _comments.clear();
      _currentPage = 1;
      _hasNext = true;

      if (_initialize) {
        _initialize = false;
      }
    });

    await _loadData();
    if (_comments.isEmpty) {
      _refreshController.loadNoData();
    } else {
      if (_hasNext) {
        _refreshController.loadComplete();
      } else {
        _refreshController.loadNoData();
      }
      if (this.mounted) {
        setState(() {
          if (!_initialize) {
            _initialize = true;
          }
        });
      }
    }

    _refreshController.refreshCompleted();
  }

  Future<void> _onLoading() async {
    await _loadData(onSuccess: () {
      if (this.mounted) {
        setState(() {
          if (_hasNext) {
            _refreshController.loadComplete();
          } else {
            _refreshController.loadNoData();
          }
        });
      }
    }, onFail: () {
      _refreshController.loadFailed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          title: Text('${widget.illustTitle}'),
          subtitle: Text('共$_total条'),
        ),
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: _initialize,
        header: MaterialClassicHeader(
          color: Colors.pinkAccent,
        ),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus? mode) {
            Widget body;
            switch (mode) {
              case LoadStatus.idle:
                body = Text("上拉,加载更多");
                break;
              case LoadStatus.canLoading:
                body = Text("松手,加载更多");
                break;
              case LoadStatus.loading:
                body = CircularProgressIndicator();
                break;
              case LoadStatus.noMore:
                body = Text("没有更多数据啦");
                break;
              case LoadStatus.failed:
                body = Text('加载失败');
                break;
              default:
                body = Container();
                break;
            }

            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: _buildBody(),
      ),
    );
  }
}
