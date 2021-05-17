/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : network_config.dart
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pixiv_xiaocao_android/config.dart';

class NetworkConfigPage extends StatefulWidget {
  @override
  _NetworkConfigPageState createState() => _NetworkConfigPageState();
}

class _NetworkConfigPageState extends State<NetworkConfigPage> {
  static final TextEditingController _proxyController =
      TextEditingController(text: '${Config.proxyIP}:${Config.proxyPort}');

  void _updateNetworkProxyEditorDialog() {
    final TextEditingController proxyIPController =
        TextEditingController(text: Config.proxyIP);

    final TextEditingController proxyPortController =
        TextEditingController(text: '${Config.proxyPort}');

    showDialog<Null>(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: '代理主机',
                    ),
                    controller: proxyIPController,
                  ),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      labelText: '代理端口',
                    ),
                    controller: proxyPortController,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                  )
                ],
              ),
            ),
            actions: [
              OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('取消')),
              OutlinedButton(
                  onPressed: () {
                    if (RegExp(
                            r'^(\d|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5]):([0-9]|[1-9]\d|[1-9]\d{2}|[1-9]\d{3}|[1-5]\d{4}|6[0-4]\d{3}|65[0-4]\d{2}|655[0-2]\d|6553[0-5])$')
                        .hasMatch(
                            '${proxyIPController.text}:${proxyPortController.text}')) {
                      setState(() {
                        Config.proxyIP = proxyIPController.text;
                        Config.proxyPort = int.parse(proxyPortController.text);

                        _proxyController.text =
                            '${Config.proxyIP}:${Config.proxyPort}';
                      });

                      Navigator.of(context).pop();
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Text('不合法的主机或端口号'),
                              actions: [
                                OutlinedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('确定'))
                              ],
                            );
                          });
                    }
                  },
                  child: Text('确定'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('网络配置'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: Text('开VPN不要启用代理(默认直连的)'),
                subtitle: Text('开VPN要用原始图片源(不然加载慢)'),
              ),
            ),
            SizedBox(height: 20),
            Card(
              child: SwitchListTile(
                  title: Text('启用代理'),
                  value: Config.enableProxy,
                  onChanged: (value) {
                    setState(() {
                      Config.enableProxy = value;
                    });
                  }),
            ),
            SizedBox(height: 20),
            Card(
              child: ListTile(
                onTap: () {
                  _updateNetworkProxyEditorDialog();
                },
                title: Text('${Config.proxyIP}:${Config.proxyPort}'),
              ),
            ),
            SizedBox(height: 20),
            Card(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Text('图片源',style: TextStyle(fontSize: 22),),
                  SizedBox(height: 20),
                  RadioListTile(
                    value: false,
                    groupValue: Config.enableImageProxy,
                    title: Text('使用原始图片源(i.pximg.net)'),
                    selected: !Config.enableImageProxy,
                    onChanged: (bool? value) {
                      if (value != null)
                        setState(() {
                          Config.enableImageProxy = value;
                        });
                    },
                  ),
                  SizedBox(height: 20),
                  RadioListTile(
                    value: true,
                    groupValue: Config.enableImageProxy,
                    title: Text('使用代理图片源(i.pixiv.cat)'),
                    selected: Config.enableImageProxy,
                    onChanged: (bool? value) {
                      if (value != null)
                        setState(() {
                          Config.enableImageProxy = value;
                        });
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
