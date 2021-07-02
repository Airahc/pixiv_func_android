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
import 'package:pixiv_xiaocao_android/utils.dart';

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
                  Utils.gotoPage(
                    context,
                    LoginPage(
                      (String cookie, String token, int id) {
                        if (id != 0) {
                          setState(() {
                            final account = AccountEntity(id, cookie, token);
                            //没有任何账号
                            if (ConfigUtil.instance.config.accounts.isEmpty) {
                              //直接加进去 并设为当前选中
                              ConfigUtil.instance.config.accounts.add(account);
                              ConfigUtil.instance.config.currentAccount =
                                  account;
                              PixivRequest.instance.updateHeaders();
                            } else {
                              //新登录的账号id是不是已经存在
                              final index = ConfigUtil.instance.config.accounts
                                  .indexWhere(
                                      (e) => e.userId == account.userId);
                              if (index == -1) {
                                //不存在 直接加进去
                                ConfigUtil.instance.config.accounts
                                    .add(account);
                              } else {
                                //存在 更新
                                ConfigUtil.instance.config.accounts[index] =
                                    account;
                                //新登录的账号的id是不是当前选择的账号的id
                                if (account.userId ==
                                    ConfigUtil.instance.config.currentAccount
                                        .userId) {
                                  //是就更新
                                  ConfigUtil.instance.config.currentAccount =
                                      account;
                                  PixivRequest.instance.updateHeaders();
                                }
                              }
                            }
                            ConfigUtil.instance.updateConfigFile();
                          });
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
                          if(ConfigUtil.instance.config.accounts.indexWhere((e) => e.userId==newData.userId)!=-1){
                            setState(() {
                              ConfigUtil.instance.config.accounts.add(newData);
                              PixivRequest.instance.updateHeaders();
                              ConfigUtil.instance.updateConfigFile();
                            });
                          }else{
                            Utils.toast('已经存在的ID');
                          }
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
            if (account.userId !=
                ConfigUtil.instance.config.currentAccount.userId) {
              setState(() {
                ConfigUtil.instance.config.currentAccount = account;
                PixivRequest.instance.updateHeaders();
                ConfigUtil.instance.updateConfigFile();
              });
            }
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
                      }
                      account = newData;
                      PixivRequest.instance.updateHeaders();
                      ConfigUtil.instance.updateConfigFile();
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
