/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:account_page.dart
 * 创建时间:2021/8/23 下午2:09
 * 作者:小草
 */
import 'package:flutter/material.dart';
import 'package:pixiv_func_android/api/entity/local_user.dart';
import 'package:pixiv_func_android/api/model/user_account.dart';
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/log/log.dart';
import 'package:pixiv_func_android/util/page_utils.dart';
import 'package:pixiv_func_android/view_model/account_model.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Widget _buildAccountListTile(AccountModel model, LocalUser account) {
    return Card(
      child: ListTile(
        onTap: () {
          model.select(account.id);
        },
        title: Text(
          account.name,
          style: account.id == accountManager.current?.user.id
              ? TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                )
              : null,
        ),
        subtitle: Text('${account.account}(${account.id})'),
        trailing: IconButton(
          tooltip: '移除这个账号',
          splashRadius: 40,
          onPressed: () {
            model.remove(
              account.id,
              back: () {
                PageUtils.back(context);
              },
            );

            homeModel.refresh();
          },
          icon: Icon(Icons.delete_forever_outlined),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AccountModel>(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          SizedBox(height: 5),
          IconButton(
            tooltip: '登录一个账号',
            onPressed: () {
              model.login(
                context,
                onLoginSuccess: (UserAccount account) {
                  Log.i(account);
                  model.add(account);
                },
              );
            },
            icon: Icon(Icons.login),
          ),
          SizedBox(height: 5),
        ],
      ),
      body: ListView(
        children: model.accounts.map((e) => _buildAccountListTile(model, e)).toList(),
      ),
    );
  }
}
