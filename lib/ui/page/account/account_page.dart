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
import 'package:pixiv_func_android/ui/widget/avatar_view_from_url.dart';
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
          '${account.name}(${account.mailAddress})',
          style: account.id == accountManager.current?.user.id
              ? TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                )
              : null,
        ),
        subtitle: Text('${account.account}(${account.id})'),
        leading: AvatarViewFromUrl(account.profileImageUrls.px50x50),
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
          icon: const Icon(Icons.delete_forever_outlined),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AccountModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('账号管理'),
        actions: [
          const SizedBox(height: 5),
          IconButton(
            tooltip: '登录一个账号',
            onPressed: () {
              showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('登录'),
                    content: const Text('是否启用本地反向代理(IP直连)?'),
                    actions: [
                      OutlinedButton(onPressed: () => Navigator.pop<bool>(context, true), child: const Text('启用')),
                      OutlinedButton(onPressed: () => Navigator.pop<bool>(context, false), child: const Text('不启用')),
                    ],
                  );
                },
              ).then((value) {
                if (null != value) {
                  model.login(
                    context,
                    onLoginSuccess: (UserAccount account) {
                      Log.i(account);
                      model.add(account);
                    },
                    useLocalReverseProxy: value,
                  );
                }
              });
            },
            icon: const Icon(Icons.login),
          ),
          const SizedBox(height: 5),
        ],
      ),
      body: ListView(
        children: [for (final account in model.accounts) _buildAccountListTile(model, account)],
      ),
    );
  }
}
