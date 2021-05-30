/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : account_page.dart
 */

import 'package:flutter/material.dart';
import 'package:pixiv_xiaocao_android/api/pixiv_request.dart';
import 'package:pixiv_xiaocao_android/config/config_entity.dart';
import 'package:pixiv_xiaocao_android/config/config_util.dart';
import 'package:pixiv_xiaocao_android/log/log_entity.dart';
import 'package:pixiv_xiaocao_android/log/log_util.dart';
import 'package:pixiv_xiaocao_android/pages/account/edit_account_dialog.dart';
import 'package:pixiv_xiaocao_android/pages/login/login_page.dart';
import 'package:pixiv_xiaocao_android/util.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  void _addAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actions: [
            OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Util.gotoPage(
                    context,
                    LoginPage(
                      (String cookie, String token, int id) {
                        if (id != 0) {
                          setState(
                            () {
                              final account = AccountEntity(id, cookie, token);
                              if (ConfigUtil.instance.config.accounts.isEmpty) {
                                ConfigUtil.instance.config.currentAccount =
                                    account;
                                PixivRequest.instance.updateHeaders();
                              }
                              ConfigUtil.instance.config.accounts.add(account);
                              ConfigUtil.instance.updateConfigFile();
                            },
                          );
                        } else {
                          LogUtil.instance.add(
                            type: LogType.Info,
                            id: id,
                            title: '登录失败',
                            url: '',
                            context: '在账号页面',
                          );
                        }
                      },
                    ),
                  );
                },
                child: Text('登录')),
            OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return EditAccountDialog(
                        originalData: AccountEntity.empty(),
                        resultCallback: (AccountEntity newData) {
                          setState(() {
                            ConfigUtil.instance.config.accounts.add(newData);
                            ConfigUtil.instance.updateConfigFile();
                            PixivRequest.instance.updateHeaders();
                          });
                        },
                      );
                    },
                  );
                },
                child: Text('输入')),
          ],
          content: Text('添加账号'),
        );
      },
    );
  }

  Widget _buildBody() {
    final list = <Widget>[];
    ConfigUtil.instance.config.accounts.forEach((account) {
      list.add(Card(
        child: ListTile(
          onTap: () {
            setState(() {
              ConfigUtil.instance.config.currentAccount = account;
              PixivRequest.instance.updateHeaders();
            });
          },
          onLongPress: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return EditAccountDialog(
                  originalData: account,
                  resultCallback: (AccountEntity newData) {
                    setState(() {
                      if (account.userId ==
                          ConfigUtil.instance.config.currentAccount.userId) {
                        ConfigUtil.instance.config.currentAccount = newData;
                        ConfigUtil.instance.updateConfigFile();
                      }
                      account = newData;
                      PixivRequest.instance.updateHeaders();
                    });
                  },
                );
              },
            );
          },
          title: Text('${account.userId}'),
          trailing:
              account.userId == ConfigUtil.instance.config.currentAccount.userId
                  ? Icon(Icons.tag)
                  : null,
          leading: IconButton(
            splashRadius: 20,
            icon: Icon(Icons.delete_outlined),
            onPressed: () {
              setState(() {
                if (account.userId ==
                    ConfigUtil.instance.config.currentAccount.userId) {
                  ConfigUtil.instance.config.currentAccount =
                      AccountEntity.empty();
                  PixivRequest.instance.updateHeaders();
                }
                ConfigUtil.instance.config.accounts.remove(account);
                ConfigUtil.instance.updateConfigFile();
              });
            },
          ),
        ),
      ));
    });
    return ListView(
      padding: EdgeInsets.all(5),
      children: list,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('账号'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _addAccountDialog();
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }
}
