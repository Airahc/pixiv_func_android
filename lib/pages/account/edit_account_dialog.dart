/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : edit_account_dialog.dart
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pixiv_xiaocao_android/api/pixiv_request.dart';
import 'package:pixiv_xiaocao_android/config/config_entity.dart';
import 'package:pixiv_xiaocao_android/config/config_util.dart';

class EditAccountDialog extends StatefulWidget {
  final AccountEntity originalData;
  final void Function(AccountEntity newData) resultCallback;

  EditAccountDialog({required this.originalData, required this.resultCallback});

  @override
  _EditAccountDialogState createState() => _EditAccountDialogState();
}

class _EditAccountDialogState extends State<EditAccountDialog> {
  late final AccountEntity _editData = widget.originalData;

  late final TextEditingController _userIdController =
      TextEditingController(text: '${_editData.userId}');

  late final TextEditingController _cookieController =
      TextEditingController(text: '${_editData.cookie}');

  late final TextEditingController _tokenController =
      TextEditingController(text: '${_editData.token}');

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        OutlinedButton(
          onPressed: () {
            widget.resultCallback(_editData);
            Navigator.of(context).pop();
          },
          child: Text('确定'),
        ),
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('取消'),
        ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('编辑账号'),
          TextField(
            controller: _userIdController,
            decoration: InputDecoration(labelText: '用户ID'),
            onChanged: (value) async {
              if (value.isNotEmpty) {
                _editData.userId = int.parse(value);
                await ConfigUtil.instance.updateConfigFile();
                PixivRequest.instance.updateHeaders();
              }
            },
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _cookieController,
            maxLines: 5,
            minLines: 1,
            decoration: InputDecoration(labelText: 'Cookie'),
            onChanged: (value) async {
              _editData.cookie = value;
              await ConfigUtil.instance.updateConfigFile();
              PixivRequest.instance.updateHeaders();
            },
          ),
          TextField(
            controller: _tokenController,
            maxLines: 5,
            minLines: 1,
            decoration: InputDecoration(labelText: 'Token'),
            onChanged: (value) async {
              _editData.token = value;
              await ConfigUtil.instance.updateConfigFile();
              PixivRequest.instance.updateHeaders();
            },
          ),
        ],
      ),
    );
  }
}
