/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:user_details.dart
 * 创建时间:2021/8/31 上午12:24
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:pixiv_func_android/api/model/user_detail.dart';
import 'package:pixiv_func_android/ui/widget/html_rich_text.dart';

class UserDetails extends StatelessWidget {
  final UserDetail detail;

  const UserDetails(this.detail, {Key? key}) : super(key: key);

  Widget _buildItem(String name, String value) {
    return Card(
      child: ListTile(
        onLongPress: () {},
        leading: Text(name),
        title: Center(
          child: Text(
            '$value',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    final user = detail.user;
    final profile = detail.profile;
    final workspace = detail.workspace;

    if (null != user.comment) {
      children.add(Card(
        child: Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.all(10),
          child: HtmlRichText(user.comment!),
        ),
      ));
    }

    //user
    children.add(Divider());
    children.add(_buildItem('ID', user.id.toString()));
    children.add(Divider());
    children.add(_buildItem('账号', user.account));
    children.add(Divider());

    //profile
    if (null != profile.webpage) {
      children.add(_buildItem('网站', profile.webpage!));
      children.add(Divider());
    }

    if (profile.birth.isNotEmpty) {
      children.add(_buildItem('出生', profile.birth));
      children.add(Divider());
    }

    children.add(_buildItem('工作', profile.job));
    children.add(Divider());

    if (null != profile.twitterUrl) {
      children.add(_buildItem('twitter', profile.twitterUrl!));
      children.add(Divider());
    }

    if (null != profile.pawooUrl) {
      children.add(_buildItem('pawoo', profile.pawooUrl!));
      children.add(Divider());
    }

    //workspace

    if (workspace.pc.isNotEmpty) {
      children.add(_buildItem('电脑', workspace.pc));
      children.add(Divider());
    }

    if (workspace.monitor.isNotEmpty) {
      children.add(_buildItem('显示器', workspace.monitor));
      children.add(Divider());
    }

    if (workspace.tool.isNotEmpty) {
      children.add(_buildItem('软件', workspace.tool));
      children.add(Divider());
    }

    if (workspace.scanner.isNotEmpty) {
      children.add(_buildItem('扫描仪', workspace.scanner));
      children.add(Divider());
    }

    if (workspace.tablet.isNotEmpty) {
      children.add(_buildItem('数位板', workspace.tablet));
      children.add(Divider());
    }

    if (workspace.mouse.isNotEmpty) {
      children.add(_buildItem('鼠标', workspace.mouse));
      children.add(Divider());
    }

    if (workspace.printer.isNotEmpty) {
      children.add(_buildItem('打印机', workspace.printer));
      children.add(Divider());
    }

    if (workspace.desktop.isNotEmpty) {
      children.add(_buildItem('桌子上的东西', workspace.desktop));
      children.add(Divider());
    }

    if (workspace.music.isNotEmpty) {
      children.add(_buildItem('画图时听的音乐', workspace.music));
      children.add(Divider());
    }

    if (workspace.desk.isNotEmpty) {
      children.add(_buildItem('桌子', workspace.desk));
      children.add(Divider());
    }

    if (workspace.chair.isNotEmpty) {
      children.add(_buildItem('椅子', workspace.chair));
      children.add(Divider());
    }

    if (workspace.comment.isNotEmpty) {
      children.add(_buildItem('其他', workspace.comment));
      children.add(Divider());
    }

    return ListView(children: children);
  }
}
