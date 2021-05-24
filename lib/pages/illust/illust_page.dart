/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : illust_page.dart
 */

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pixiv_xiaocao_android/api/entity/bookmark_add/bookmark_add.dart';
import 'package:pixiv_xiaocao_android/api/entity/illust_info/illust_image.dart';
import 'package:pixiv_xiaocao_android/api/entity/illust_info/illust_info_body.dart';
import 'package:pixiv_xiaocao_android/api/pixiv_request.dart';
import 'package:pixiv_xiaocao_android/component/avatar_view_from_url.dart';
import 'package:pixiv_xiaocao_android/component/bookmark_add_dialog_content.dart';
import 'package:pixiv_xiaocao_android/component/image_scale.dart';
import 'package:pixiv_xiaocao_android/component/image_view_from_url.dart';
import 'package:pixiv_xiaocao_android/log/log_entity.dart';
import 'package:pixiv_xiaocao_android/log/log_util.dart';
import 'package:pixiv_xiaocao_android/pages/illust/illust_comments.dart';
import 'package:pixiv_xiaocao_android/pages/illust/illust_related.dart';
import 'package:pixiv_xiaocao_android/pages/user/user_page.dart';
import 'package:pixiv_xiaocao_android/util.dart';

typedef OnBookmarkAdd = void Function(int bookmarkId);
typedef OnBookmarkDelete = void Function();

class IllustPage extends StatefulWidget {
  final int illustId;
  final OnBookmarkAdd? onBookmarkAdd;
  final OnBookmarkDelete? onBookmarkDelete;

  IllustPage(this.illustId, {this.onBookmarkAdd, this.onBookmarkDelete});

  @override
  _IllustPageState createState() => _IllustPageState();
}

class _IllustPageState extends State<IllustPage> {
  IllustInfoBody? _illustInfoData;

  bool _loading = false;

  @override
  void initState() {
    _loadData(reload: false);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future _loadData({bool reload = true}) async {
    if (this.mounted) {
      setState(() {
        if (reload) {
          _illustInfoData = null;
        }
        _loading = true;
      });
    } else {
      return;
    }

    var illustInfo = await PixivRequest.instance.queryIllustInfo(
      widget.illustId,
      requestException: (e) {
        LogUtil.instance.add(
          type: LogType.NetworkException,
          id: widget.illustId,
          title: '查询插画信息失败',
          url: '',
          context: '在插画页面',
          exception: e,
        );
      },
      decodeException: (e, response) {
        LogUtil.instance.add(
          type: LogType.DeserializationException,
          id: widget.illustId,
          title: '查询插画信息反序列化异常',
          url: '',
          context: response,
          exception: e,
        );
      },
    );

    if (this.mounted && illustInfo != null) {
      if (illustInfo.error) {
        LogUtil.instance.add(
          type: LogType.Info,
          id: widget.illustId,
          title: '查询插画信息失败',
          url: '',
          context: 'error:${illustInfo.message}',
        );
      }
      setState(() {
        _illustInfoData = illustInfo.body;
      });
    } else {
      return;
    }

    if (this.mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  int? get _bookmarkId => _illustInfoData?.illustDetails.bookmarkId;

  set _bookmarkId(int? value) {
    _illustInfoData!.illustDetails.bookmarkId = value;
  }

  String? get _getIllustComment {
    return _illustInfoData?.illustDetails.comment;
  }

  List<Widget> _buildImageList(List<IllustImage> illustImages,
      List<String> imageUrls, List<String> imageOriginalUrls) {
    final list = <Widget>[];

    for (var i = 0; i < illustImages.length; i++) {
      list.add(
        GestureDetector(
          onTap: () {
            Util.gotoPage(context, ImageScale(imageOriginalUrls, i));
          },
          child: ImageViewFromUrl(imageUrls[i]),
        ),
      );
      list.add(SizedBox(height: 5));
      list.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                '宽:${illustImages[i].illustImageWidth} 高:${illustImages[i].illustImageHeight}'),
            IconButton(
              onPressed: () {
                Util.saveImage(
                  _illustInfoData!.illustDetails.id,
                  _illustInfoData!.illustDetails.url,
                  _illustInfoData!.illustDetails.title,
                );
              },
              splashRadius: 20,
              icon: Icon(Icons.save_alt),
            )
          ],
        ),
      );
    }

    return list;
  }

  Widget _buildImagePreviewCard() {
    final imageUrls = <String>[];
    final imageOriginalUrls = <String>[];
    if (_illustInfoData!.illustDetails.mangaA != null) {
      _illustInfoData!.illustDetails.mangaA!.forEach((manga) {
        imageUrls.add(manga.url);
        imageOriginalUrls.add(manga.urlBig);
      });
    } else {
      imageUrls.add(_illustInfoData!.illustDetails.url);
      imageOriginalUrls.add(_illustInfoData!.illustDetails.urlBig!);
    }

    return Card(
      child: Column(
        children: _buildImageList(
          _illustInfoData!.illustDetails.illustImages,
          imageUrls,
          imageOriginalUrls,
        ),
      ),
    );
  }

  void _copyDialog(String value) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('取消'),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Util.copyToClipboard('$value');
              },
              child: Text('确定'),
            ),
          ],
          content: Text('复制到剪切板?'),
        );
      },
    );
  }

  Widget _buildTagsView() {
    final list = <Widget>[];

    _illustInfoData!.illustDetails.displayTags.forEach((displayTag) {
      final textSpans = <TextSpan>[];
      textSpans.add(TextSpan(
        text: '${displayTag.tag}',
        style: TextStyle(color: Colors.pinkAccent),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            _copyDialog(displayTag.tag);
          },
      ));

      if (displayTag.translation != null) {
        textSpans.add(TextSpan(
          text: '  #${displayTag.translation}',
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              if (displayTag.translation != null &&
                  displayTag.translation!.isNotEmpty) {
                _copyDialog(displayTag.translation!);
              }
            },
        ));
      }
      list.add(Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.cyan),
            borderRadius: BorderRadius.circular(5)),
        child: Container(
          padding: EdgeInsets.all(5),
          child: Text.rich(
            TextSpan(
              children: textSpans,
            ),
          ),
        ),
      ));
    });

    return Wrap(
      alignment: WrapAlignment.start,
      runSpacing: 5,
      spacing: 5,
      children: list,
    );
  }

  Widget _buildDetails() {
    return Container(
      child: ListTile(
        title: Center(
          child: Text(
            _illustInfoData!.illustDetails.title,
            style: TextStyle(color: Colors.pinkAccent),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        subtitle: Center(
          child: Text(
            Util.dateTimeToString(
              DateTime.fromMillisecondsSinceEpoch(
                _illustInfoData!.illustDetails.uploadTimestamp * 1000,
              ),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Widget? _buildBookmarkButton() {
    if (_illustInfoData == null) {
      return null;
    }
    return FloatingActionButton(
      backgroundColor: Colors.white,
      onPressed: () async {
        if (_bookmarkId != null) {
          final bookmarkDelete =
              await PixivRequest.instance.bookmarkDelete(_bookmarkId!);
          if (bookmarkDelete != null) {
            if (!bookmarkDelete.error) {
              if (bookmarkDelete.isSucceed) {
                setState(() {
                  _bookmarkId = null;
                });
                widget.onBookmarkDelete?.call();
              } else {
                LogUtil.instance.add(
                  type: LogType.Info,
                  id: widget.illustId,
                  title: '删除书签失败',
                  url: '',
                  context: '',
                );
              }
            } else {
              LogUtil.instance.add(
                type: LogType.Info,
                id: widget.illustId,
                title: '删除书签失败',
                url: '',
                context: 'error:${bookmarkDelete.message}',
              );
            }
          }
        } else {
          showDialog<Null>(
            context: context,
            builder: (context) {
              return BookmarkAddDialogContent(
                widget.illustId,
                (BookmarkAdd? bookmarkAdd) {
                  if (bookmarkAdd != null) {
                    if (!bookmarkAdd.error) {
                      if (bookmarkAdd.isSucceed) {
                        if (bookmarkAdd.lastBookmarkId != null) {
                          setState(() {
                            _bookmarkId = bookmarkAdd.lastBookmarkId;
                          });
                          widget.onBookmarkAdd
                              ?.call(bookmarkAdd.lastBookmarkId!);
                        }
                      } else {
                        LogUtil.instance.add(
                          type: LogType.Info,
                          id: widget.illustId,
                          title: '添加书签失败',
                          url: '',
                          context: '',
                        );
                      }
                    } else {
                      LogUtil.instance.add(
                        type: LogType.Info,
                        id: widget.illustId,
                        title: '添加书签失败',
                        url: '',
                        context: 'error:${bookmarkAdd.message}',
                      );
                    }
                  }
                },
              );
            },
          );
        }
      },
      child: Icon(
        _bookmarkId != null
            ? Icons.favorite_sharp
            : Icons.favorite_outline_sharp,
        color: _bookmarkId != null ? Colors.pinkAccent : Colors.black54,
      ),
    );
  }

  Widget _buildBody() {
    late Widget component;

    if (_illustInfoData != null) {
      final list = <Widget>[];
      list.add(_buildImagePreviewCard());
      list.add(_buildDetails());
      list.add(SizedBox(height: 10));
      list.add(_buildTagsView());
      list.add(SizedBox(height: 10));
      if (_getIllustComment != null) {
        list.add(Card(
          child: Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.all(10),
            child: SelectableText(_getIllustComment!),
          ),
        ));
      }
      list.add(
        InkWell(
          onTap: () {
            Util.gotoPage(
              context,
              IllustCommentsPage(_illustInfoData!.illustDetails.id,
                  _illustInfoData!.illustDetails.title),
            );
          },
          child: Card(
            child: ListTile(
              leading: Icon(Icons.comment),
              title: Center(
                child: Text('查看评论'),
              ),
            ),
          ),
        ),
      );

      list.add(ListTile(title: Center(child: Text('相关推荐'))));

      list.add(IllustRelatedContent(widget.illustId));
      component = SingleChildScrollView(
        child: Center(
          child: Column(
            children: list,
          ),
        ),
      );
    } else {
      if (_loading) {
        component =
            Container(child: Center(child: CircularProgressIndicator()));
      } else {
        component = ListView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Center(
                child: Text('没有任何数据'),
              ),
            );
          },
          physics: const AlwaysScrollableScrollPhysics(),
        );
      }
    }

    return Scrollbar(
      radius: Radius.circular(10),
      thickness: 10,
      child: component,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _buildBookmarkButton(),
      appBar: AppBar(
        title: ListTile(
          contentPadding: EdgeInsets.all(0),
          trailing: IconButton(
            splashRadius: 20,
            icon: Icon(Icons.refresh_outlined),
            onPressed: _loadData,
          ),
          leading: _illustInfoData != null
              ? GestureDetector(
                  onTap: () {
                    Util.gotoPage(context,
                        UserPage(_illustInfoData!.authorDetails.userId));
                  },
                  child: AvatarViewFromUrl(
                    _illustInfoData!.authorDetails.profileImg.values.last,
                  ),
                )
              : null,
          title: InkWell(
            child: Text('插画ID:${widget.illustId}'),
            onLongPress: () {
              Util.copyToClipboard('${widget.illustId}');
              Util.toastIconAndText(
                Icons.copy_outlined,
                '已将插画ID复制到剪切板',
              );
            },
          ),
          subtitle: _illustInfoData != null
              ? Text('总收藏:${_illustInfoData!.illustDetails.bookmarkUserTotal}')
              : null,
        ),
      ),
      body: _buildBody(),
    );
  }
}
