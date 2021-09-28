/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:download_task_page.dart
 * 创建时间:2021/9/5 下午11:53
 * 作者:小草
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pixiv_func_android/downloader/downloader.dart';
import 'package:pixiv_func_android/model/download_task.dart';
import 'package:pixiv_func_android/ui/page/illust/illust_content_page.dart';
import 'package:pixiv_func_android/util/page_utils.dart';
import 'package:pixiv_func_android/view_model/download_task_model.dart';

class DownloadTaskPage extends StatelessWidget {
  const DownloadTaskPage({Key? key}) : super(key: key);

  Widget _buildItem(BuildContext context, DownloadTask task) {
    final Widget trailing;

    switch (task.state) {
      case DownloadState.idle:
        trailing = Container();
        break;
      case DownloadState.downloading:
        trailing = const RefreshProgressIndicator();
        break;
      case DownloadState.failed:
        trailing = IconButton(
          splashRadius: 20,
          onPressed: () => Downloader.start(illust: task.illust, url: task.originalUrl, id: task.id),
          icon: const Icon(Icons.refresh_outlined),
        );
        break;
      case DownloadState.complete:
        trailing = const Icon(Icons.file_download_done);
        break;
    }

    return Card(
      child: ListTile(
        onTap: () => PageUtils.to(context, IllustContentPage(task.illust)),
        title: Text(task.illust.title, overflow: TextOverflow.ellipsis),
        subtitle:
            DownloadState.failed != task.state ? LinearProgressIndicator(value: task.progress) : const Text('下载失败'),
        trailing: SizedBox(
          width: 48,
          child: trailing,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<DownloadTaskModel>(context);
    return ListView(
      children: [for (final task in model.tasks) _buildItem(context, task)],
    );
  }
}
