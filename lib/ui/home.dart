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
import 'package:pixiv_func_android/view_model/home_model.dart';
import 'package:pixiv_func_android/util/page_utils.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  Widget _buildAppBody(BuildContext context, HomeModel model) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pixiv Func'),
      ),
      body: IndexedStack(
        index: model.currentPage,
        children: model.navigationPages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: model.currentPage,
        onTap: (int index) => model.currentPage = index,
        items: const [
          BottomNavigationBarItem(
            label: '推荐作品',
            icon: Icon(Icons.alt_route_outlined),
          ),
          BottomNavigationBarItem(
            label: '排行榜',
            icon: Icon(Icons.leaderboard_outlined),
          ),
          BottomNavigationBarItem(
            label: '下载任务',
            icon: Icon(Icons.download_outlined),
          ),
        ],
      ),
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: ListView(
            children: model.pages
                .map(
                  (page) => Card(
                    margin: const EdgeInsets.all(1),
                    child: ListTile(
                      title: Text(page.name),
                      onTap: () {
                        PageUtils.back(context);
                        PageUtils.to(context, page.widget);
                      },
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildGuideBody(BuildContext context, HomeModel model) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pixiv Func'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 100),
          ListTile(
            title: Row(
              children: [
                const Text('该软件使用'),
                Image.asset(
                  'assets/dart-logo.png',
                  width: 30,
                  height: 30,
                ),
                const Text('与'),
                Image.asset(
                  'assets/kotlin-logo.png',
                  width: 30,
                  height: 30,
                ),
                const Text('开发 开源且免费'),
              ],
            ),
            subtitle: const Text('禁止用于商业用途(包括收取打赏)'),
          ),
          const ListTile(
            title: Text('请打开你的代理(VPN)然后进行登录操作'),
            subtitle: Text('登录完关掉就可以免代理直连'),
          ),
          const Divider(),
          Card(
            child: ListTile(
              onTap: model.agreementAccepted ? () => _login(context, model) : null,
              title: const Center(child: Text('登录')),
            ),
          ),
          Card(
            child: ListTile(
              onTap: model.agreementAccepted ? () => _login(context, model, create: true) : null,
              title: const Center(child: Text('注册')),
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
                    const TextSpan(text: '我同意并接受'),
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

  void _login(BuildContext context, HomeModel model, {bool create = false}) {
    showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('登录'),
          content: const Text('是否启用本地反向代理(IP直连)?'),
          actions: [
            OutlinedButton(onPressed: () => Navigator.pop<bool>(context, true), child: const Text('使用')),
            OutlinedButton(onPressed: () => Navigator.pop<bool>(context, false), child: const Text('不使用')),
          ],
        );
      },
    ).then((value) {
      if (null != value) {
        accountModel.login(
          context,
          onLoginSuccess: (UserAccount account) async {
            Log.i(account);
            accountModel.add(account);
            platformAPI.toast('登录成功');
            model.refresh();
          },
          create: create,
          useLocalReverseProxy: value,
        );
      }
    });
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
