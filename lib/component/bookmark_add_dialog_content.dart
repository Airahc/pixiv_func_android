/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : bookmark_add_dialog_content.dart
 */

import 'package:flutter/material.dart';
import 'package:pixiv_xiaocao_android/api/pixiv_request.dart';

class BookmarkAddDialogContent extends StatefulWidget {
  final int illustId;

  final void Function(bool success, int? bookmarkId) resultCallback;

  BookmarkAddDialogContent(
    this.illustId,
    this.resultCallback,
  );

  @override
  _BookmarkAddDialogContentState createState() =>
      _BookmarkAddDialogContentState();
}

class _BookmarkAddDialogContentState extends State<BookmarkAddDialogContent> {
  var tags = <String>[];
  var tagInputController = TextEditingController();
  String comment = '';

  // String _time(DateTime dateTime) {
  //   return '${dateTime.year}年${dateTime.month}月${dateTime.day}日 ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
  // }

  Future onAdd() async {
    final result = await PixivRequest.instance.bookmarkAdd(widget.illustId,
        comment: comment, tags: tags, decodeException: (e, response) {
      print(e);
    }, requestException: (e) {
      print(e);
    });
    if (this.mounted) {
      if (result != null) {
        widget.resultCallback(result.body != null, result.body?.lastBookmarkId);
        if (result.error) {
          print('error:${result.message}');
        }
      }
    }
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
          onPressed: () async {
            await onAdd();
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