/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:illust_page.dart
 * 创建时间:2021/9/11 上午10:19
 * 作者:小草
 */
import 'package:flutter/material.dart';
import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/provider/view_state.dart';
import 'package:pixiv_func_android/ui/page/illust/illust_content_page.dart';
import 'package:pixiv_func_android/view_model/illust_model.dart';

class IllustPage extends StatelessWidget {
  final int id;

  const IllustPage(this.id, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      model: IllustModel(id),
      builder: (BuildContext context, IllustModel model, Widget? child) {
        if (ViewState.busy == model.viewState) {
          return Scaffold(
            appBar: AppBar(title: const Text('用户')),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (ViewState.initFailed == model.viewState) {
          return Scaffold(
            appBar: AppBar(title: const Text('用户')),
            body: Center(
              child: ListTile(
                onTap: model.loadData,
                title: const Center(
                  child: Text('加载失败,点击重新加载'),
                ),
              ),
            ),
          );
        } else if (ViewState.empty == model.viewState) {
          return Scaffold(
            appBar: AppBar(title: const Text('插画详细')),
            body: Center(
              child: ListTile(
                title: Center(
                  child: Text('插画ID:$id不存在'),
                ),
              ),
            ),
          );
        }

        if (!model.initialized) {
          return Scaffold(
            appBar: AppBar(title: const Text('插画详细')),
            body: Center(
              child: ListTile(
                title: Center(
                  child: Text('插画ID:$id不存在'),
                ),
              ),
            ),
          );
        }
        return IllustContentPage(model.illustDetail!.illust);
      },
      onModelReady: (IllustModel model) => model.loadData(),
    );
  }
}
