/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : log_page.dart
 */

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pixiv_xiaocao_android/image_manager.dart';
import 'package:pixiv_xiaocao_android/log/log_entity.dart';
import 'package:pixiv_xiaocao_android/log/log_util.dart';
import 'package:pixiv_xiaocao_android/utils.dart';

class LogPage extends StatefulWidget {
  LogPage(Key? key) : super(key: key);

  @override
  LogPageState createState() => LogPageState();
}

class LogPageState extends State<LogPage> {
  static List<LogEntity> _logList = <LogEntity>[];

  void addLog({
    required LogType type,
    required int id,
    required String title,
    required String url,
    required String context,
    Exception? exception,
  }) {
    setState(() {
      _logList.add(
        LogEntity(
            DateTime.now().toLocal(), type, id, title, url, context, exception),
      );
    });
  }

  void clearLog() {
    setState(() {
      _logList.clear();
    });
  }

  void _copyDialog(String value) {
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
                Utils.copyToClipboard('$value');
              },
              child: Text('确定'),
            ),
          ],
          content: Text('复制到剪切板?'),
        );
      },
    );
  }

  void _logDetailsDialog(LogEntity log) {
    showDialog<Null>(
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black54,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  child: ListTile(
                    onLongPress: () {
                      _copyDialog(Utils.dateTimeToString(log.dateTime));
                    },
                    title: Text(Utils.dateTimeToString(log.dateTime)),
                    subtitle: Text(
                      '时间',
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    onLongPress: () {
                      _copyDialog(log.type.toString());
                    },
                    title: Text(log.type.toString()),
                    subtitle: Text(
                      '类型',
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    onLongPress: () {
                      _copyDialog(log.id.toString());
                    },
                    title: Text(log.id.toString()),
                    subtitle: Text(
                      'ID',
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                ),
                log.url.isNotEmpty
                    ? Card(
                        child: ListTile(
                          onLongPress: () {
                            _copyDialog(log.url);
                          },
                          title: Text(log.url),
                          subtitle: Text(
                            'URL',
                            style: TextStyle(color: Colors.white54),
                          ),
                        ),
                      )
                    : Container(),
                log.exception != null
                    ? Card(
                        child: InkWell(
                          onLongPress: () {
                            _copyDialog(log.exception.toString());
                          },
                          child: Text(log.exception.toString()),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        );
      },
      context: context,
    );
  }

  Widget _buildBody() {
    return ListView(
      children: _logList.map(
        (log) {
          switch (log.type) {
            case LogType.NetworkException:
              return Card(
                child: ExpansionTile(
                  title: Text('网络异常'),
                  subtitle: Text(
                    Utils.dateTimeToString(log.dateTime),
                    style: TextStyle(color: Colors.white54),
                  ),
                  children: [
                    ListTile(
                      title: Text(
                        log.title,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(log.context),
                      leading: IconButton(
                        splashRadius: 20,
                        icon: Icon(Icons.description_outlined),
                        onPressed: () {
                          _logDetailsDialog(log);
                        },
                      ),
                      trailing: IconButton(
                        splashRadius: 20,
                        icon: Icon(Icons.copy_outlined),
                        onPressed: () {
                          Utils.copyToClipboard(log.toString());
                        },
                      ),
                    ),
                  ],
                ),
              );
            case LogType.DeserializationException:
              return Card(
                child: ExpansionTile(
                  title: Text('反序列化异常'),
                  subtitle: Text(
                    Utils.dateTimeToString(log.dateTime),
                    style: TextStyle(color: Colors.white54),
                  ),
                  children: [
                    ListTile(
                      title: Text(
                        log.title,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(log.context),
                      leading: IconButton(
                        splashRadius: 20,
                        icon: Icon(Icons.description_outlined),
                        onPressed: () {
                          _logDetailsDialog(log);
                        },
                      ),
                      trailing: IconButton(
                        splashRadius: 20,
                        icon: Icon(Icons.copy_outlined),
                        onPressed: () {
                          Utils.copyToClipboard(log.toString());
                        },
                      ),
                    ),
                  ],
                ),
              );
            case LogType.DownloadFail:
              return Card(
                child: ExpansionTile(
                  title: Text('下载失败'),
                  subtitle: Text(
                    Utils.dateTimeToString(log.dateTime),
                    style: TextStyle(color: Colors.white54),
                  ),
                  children: [
                    ListTile(
                      title: Text(
                        log.title,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(log.context),
                      leading: IconButton(
                        splashRadius: 20,
                        icon: Icon(Icons.description_outlined),
                        onPressed: () {
                          _logDetailsDialog(log);
                        },
                      ),
                      trailing: IconButton(
                        splashRadius: 20,
                        icon: Icon(Icons.refresh_outlined),
                        onPressed: () {
                          ImageManager.save(SaveImageTask(
                            id: log.id,
                            url: log.url,
                            title: log.title,
                          ));

                        },
                      ),
                    ),
                  ],
                ),
              );
            case LogType.SaveFileFail:
              return Card(
                child: ExpansionTile(
                  title: Text('保存文件失败'),
                  subtitle: Text(
                    Utils.dateTimeToString(log.dateTime),
                    style: TextStyle(color: Colors.white54),
                  ),
                  children: [
                    ListTile(
                      title: Text(
                        log.title,
                        overflow: TextOverflow.ellipsis,
                      ),
                      leading: IconButton(
                        splashRadius: 20,
                        icon: Icon(Icons.description_outlined),
                        onPressed: () {
                          _logDetailsDialog(log);
                        },
                      ),
                      subtitle: Text(log.context),
                      trailing: IconButton(
                        splashRadius: 20,
                        icon: Icon(Icons.refresh_outlined),
                        onPressed: () {
                          ImageManager.save(SaveImageTask(
                            id: log.id,
                            url: log.url,
                            title: log.title,
                          ));
                        },
                      ),
                    ),
                  ],
                ),
              );
            case LogType.Info:
              return Card(
                child: ExpansionTile(
                  title: Text('信息'),
                  subtitle: Text(
                    Utils.dateTimeToString(log.dateTime),
                    style: TextStyle(color: Colors.white54),
                  ),
                  children: [
                    ListTile(
                      title: Text(
                        log.title,
                        overflow: TextOverflow.ellipsis,
                      ),
                      leading: IconButton(
                        splashRadius: 20,
                        icon: Icon(Icons.description_outlined),
                        onPressed: () {
                          _logDetailsDialog(log);
                        },
                      ),
                      subtitle: Text(log.context),
                    ),
                  ],
                ),
              );
          }
        },
      ).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('日志'),
        actions: [
          IconButton(
            splashRadius: 20,
            icon: Icon(Icons.delete_forever_outlined),
            onPressed: () {
              LogUtil.instance.clear();
            },
          )
        ],
      ),
      body: _buildBody(),
    );
  }
}
