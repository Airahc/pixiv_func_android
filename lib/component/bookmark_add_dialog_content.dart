/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : bookmark_add_dialog_content.dart
 */

import 'package:flutter/material.dart';
import 'package:pixiv_xiaocao_android/api/entity/bookmark_add/bookmark_add.dart';
import 'package:pixiv_xiaocao_android/api/pixiv_request.dart';
import 'package:pixiv_xiaocao_android/log/log_entity.dart';
import 'package:pixiv_xiaocao_android/log/log_util.dart';

class BookmarkAddDialogContent extends StatefulWidget {
  final int illustId;

  final void Function(BookmarkAdd? bookmarkAdd) resultCallback;

  BookmarkAddDialogContent(
    this.illustId,
    this.resultCallback,
  );

  @override
  _BookmarkAddDialogContentState createState() =>
      _BookmarkAddDialogContentState();
}

class _BookmarkAddDialogContentState extends State<BookmarkAddDialogContent> {
  final tags = <String>[];
  final tagInputController = TextEditingController();
  String comment = '';

  Future onAdd() async {
    final bookmarkAdd = await PixivRequest.instance.bookmarkAdd(
      widget.illustId,
      comment: comment,
      tags: tags,
      requestException: (e) {
        LogUtil.instance.add(
          type: LogType.NetworkException,
          id: widget.illustId,
          title: '添加书签失败',
          url: '',
          context: '在添加书签对话框',
          exception: e,
        );
      },
      decodeException: (e, response) {
        LogUtil.instance.add(
          type: LogType.DeserializationException,
          id: widget.illustId,
          title: '添加书签反序列化异常',
          url: '',
          context: response,
          exception: e,
        );
      },
    );
    widget.resultCallback.call(bookmarkAdd);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('取消')),
        OutlinedButton(
          onPressed: () {
            onAdd();
            Navigator.of(context).pop();
          },
          child: Text('添加'),
        ),
      ],
      content: Container(
        height: 400,
        width: 300,
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: '备注',
              ),
            ),
            TextField(
              controller: tagInputController,
              decoration: InputDecoration(
                labelText: '标签',
                suffixIcon: InkWell(
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: Icon(Icons.add_sharp),
                  onTap: () {
                    if (tagInputController.value.text.isNotEmpty &&
                        tags.length < 10) {
                      setState(() {
                        tags.add(tagInputController.value.text);
                        tagInputController.clear();
                      });
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 5,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: tags
                      .map((tag) => Container(
                              child: Stack(children: [
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.pinkAccent),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(10, 5, 15, 5),
                                child: Text(tag),
                              ),
                            ),
                            Positioned(
                              right: 2,
                              top: 2,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    tags.remove(tag);
                                  });
                                },
                                child: Icon(Icons.close_sharp, size: 15),
                              ),
                            )
                          ])))
                      .toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
