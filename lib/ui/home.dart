/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:home.dart
 * 创建时间:2021/8/20 下午12:38
 * 作者:小草
 */
import 'package:flutter/material.dart';
import 'package:pixiv_func_android/api/model/user_account.dart';
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/log/log.dart';
import 'package:pixiv_func_android/ui/page/about/about_page.dart';
import 'package:pixiv_func_android/view_model/home_model.dart';
import 'package:pixiv_func_android/util/page_utils.dart';
import 'package:pixiv_func_android/ui/page/account/account_page.dart';
import 'package:pixiv_func_android/ui/page/settings/settings_page.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  Widget _buildAppBody(BuildContext context, HomeModel model) {
    final pages = model.navigationPages.map((navigationPage) => navigationPage.page).toList();
    final drawerItems = <Widget>[];
    for (int i = 0; i < model.navigationPages.length; i++) {
      drawerItems.add(
        Card(
          child: ListTile(
            title: Text(
              model.navigationPages[i].name,
              style: TextStyle(
                color: i == model.currentPage ? Theme.of(context).colorScheme.primary : null,
              ),
            ),
            onTap: () {
              PageUtils.back(context);
              model.currentPage = i;
            },
          ),
        ),
      );
    }

    drawerItems.addAll(
      [
        Divider(),
        Card(
          child: ListTile(
            title: Text('设置'),
            onTap: () {
              PageUtils.back(context);
              PageUtils.to(context, SettingsPage());
            },
          ),
        ),
        Card(
          child: ListTile(
            title: Text('账号'),
            onTap: () {
              PageUtils.back(context);
              PageUtils.to(context, AccountPage());
            },
          ),
        ),
        Card(
          child: ListTile(
            title: Text('关于'),
            onTap: () {
              PageUtils.back(context);
              PageUtils.to(context, AboutPage());
            },
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Pixiv Func'),
      ),
      body: IndexedStack(
        index: model.currentPage,
        children: pages,
      ),
      drawer: Drawer(
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: ListView(
            children: drawerItems,
          ),
        ),
      ),
    );
  }

  Widget _buildGuideBody(BuildContext context, HomeModel model) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pixiv Func'),
      ),
      body: Column(
        children: [
          SizedBox(height: 100),
          ListTile(
            title: Row(
              children: [
                Text('该软件使用'),
                Image.asset(
                  'assets/dart-logo.png',
                  width: 30,
                  height: 30,
                ),
                Text('与'),
                Image.asset(
                  'assets/kotlin-logo.png',
                  width: 30,
                  height: 30,
                ),
                Text('开发 开源且免费'),
              ],
            ),
            subtitle: Text('禁止用于商业用途(包括收取打赏)'),
          ),
          ListTile(
            title: Text('请打开你的代理(VPN)然后进行登录操作'),
            subtitle: Text('登录完关掉就可以免代理直连'),
          ),
          Divider(),
          Card(
            child: ListTile(
              onTap: model.agreementAccepted ? () => _login(context, model) : null,
              title: Center(child: Text('登录')),
            ),
          ),
          Card(
            child: ListTile(
              onTap: model.agreementAccepted ? () => _login(context, model, true) : null,
              title: Center(child: Text('注册')),
            ),
          ),
          Card(
            child: CheckboxListTile(
              activeColor: Theme.of(context).colorScheme.primary,
              value: model.agreementAccepted,
              onChanged: (bool? value) {
                if (null != value) {
                  model.agreementAccepted = value;
                }
              },
              title: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: '我同意并接受'),
                    TextSpan(
                      text: '夹批搪与牲口不得使用此软件',
                      style: TextStyle(color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _login(BuildContext context, HomeModel model, [bool create = false]) {
    accountModel.login(
      context,
      onLoginSuccess: (UserAccount account) async {
        Log.i(account);
        accountModel.add(account);
        await platformAPI.toast('登录成功');
        model.refresh();
      },
      create: create,
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<HomeModel>(context);
    if (-1 == accountManager.index) {
      return _buildGuideBody(context, model);
    } else {
      return _buildAppBody(context, model);
    }
  }
}
