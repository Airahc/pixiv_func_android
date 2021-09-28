/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:refresher_footer.dart
 * 创建时间:2021/8/25 上午11:44
 * 作者:小草
 */
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RefresherFooter extends StatelessWidget {
  const RefresherFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFooter(
      builder: (BuildContext context, LoadStatus? mode) {
        final Widget body;
        switch (mode) {
          case LoadStatus.idle:
            body = const Text("上拉,加载更多");
            break;
          case LoadStatus.canLoading:
            body = const Text("松手,加载更多");
            break;
          case LoadStatus.loading:
            body = const CircularProgressIndicator();
            break;
          case LoadStatus.noMore:
            body = const Text("没有更多数据啦");
            break;
          case LoadStatus.failed:
            body = const Text('加载失败,请重试');
            break;
          default:
            body = Container();
            break;
        }
        return SizedBox(height: 55.0, child: Center(child: body));
      },
    );
  }
}
