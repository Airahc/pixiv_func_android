/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : user_details_dialog.dart
 */

import 'package:flutter/material.dart';
import 'package:pixiv_xiaocao_android/api/entity/user_info/user_details.dart';
import 'package:pixiv_xiaocao_android/util.dart';
import 'package:pixiv_xiaocao_android/component/avatar_view_from_url.dart';

class UserDetailsDialog extends StatefulWidget {
  final UserDetails userDetails;

  UserDetailsDialog(this.userDetails);

  @override
  _UserDetailsDialogState createState() => _UserDetailsDialogState();
}

class _UserDetailsDialogState extends State<UserDetailsDialog> {
  Widget _userInfoItem(String name, String value) {
    return ListTile(
      onLongPress: () {
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
            });
      },
      leading: Text(
        name,
      ),
      title: Center(
        child: Text(
          '$value',
        ),
      ),
    );
  }

  List<Widget> _createUserInfoList() {
    var list = <Widget>[];

    list.add(AvatarViewFromUrl(widget.userDetails.profileImg.main));
    list.add(SizedBox(height: 20));
    list.add(Card(
      child: Container(
        child: SelectableText(
          '${widget.userDetails.userComment}',
        ),
      ),
    ));

    list.add(SizedBox(height: 20));
    list.add(_userInfoItem('名称', '${widget.userDetails.userName}'));
    list.add(Divider());

    list.add(_userInfoItem('用户ID', '${widget.userDetails.userId}'));
    list.add(Divider());

    if (widget.userDetails.userWebpage.isNotEmpty) {
      list.add(_userInfoItem('网站', '${widget.userDetails.userWebpage}'));
      list.add(Divider());
    }

    if (widget.userDetails.userSexTxt != null) {
      list.add(_userInfoItem('性别', '${widget.userDetails.userSexTxt}'));
      list.add(Divider());
    }

    if (widget.userDetails.userAge != null) {
      list.add(_userInfoItem('年龄', '${widget.userDetails.userAge}'));
      list.add(Divider());
    }

    if (widget.userDetails.userBirthTxt != null) {
      list.add(_userInfoItem('生日', '${widget.userDetails.userBirthTxt}'));
      list.add(Divider());
    }

    if (widget.userDetails.userCountry != null) {
      list.add(_userInfoItem('国家', '${widget.userDetails.userCountry}'));
      list.add(Divider());
    }

    if (widget.userDetails.location != null) {
      list.add(_userInfoItem('地区', '${widget.userDetails.location}'));
      list.add(Divider());
    }

    if (widget.userDetails.userJobTxt != null) {
      list.add(_userInfoItem('工作', '${widget.userDetails.userJobTxt}'));
      list.add(Divider());
    }

    if (widget.userDetails.social != null) {
      widget.userDetails.social!.forEach((key, value) {
        list.add(_userInfoItem(key, value.values.first));
        list.add(Divider());
      });
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Container(
      color: Colors.black45,
      // width: 400,
      child: SingleChildScrollView(
        child: Column(
          children: _createUserInfoList(),
        ),
      ),
    ));
  }
}
