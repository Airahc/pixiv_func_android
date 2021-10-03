/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:following_user_page.dart
 * 创建时间:2021/8/29 下午11:22
 * 作者:小草
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/ui/widget/refresher_widget.dart';
import 'package:pixiv_func_android/ui/widget/user_preview_card.dart';
import 'package:pixiv_func_android/view_model/following_user_model.dart';

class FollowingUserPage extends StatelessWidget {
  final int id;

  const FollowingUserPage(this.id, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      model: FollowingUserModel(id),
      builder: (BuildContext context, FollowingUserModel model, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('关注的用户'),
          ),
          body: Column(
            children: [
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return SizedBox(
                    width: constraints.maxWidth,
                    child: CupertinoSlidingSegmentedControl(
                      children: <bool, Widget>{
                        true: Container(
                          alignment: Alignment.center,
                          child: const Text('公开'),
                          width: constraints.maxWidth / 2,
                        ),
                        false: Container(
                          alignment: Alignment.center,
                          child: const Text('私有'),
                          width: constraints.maxWidth / 2,
                        ),
                      },
                      groupValue: model.restrict,
                      onValueChanged: (bool? value) {
                        if (null != value) {
                          model.restrict = value;
                        }
                      },
                    ),
                  );
                },
              ),
              Expanded(
                child: RefresherWidget(
                  model,
                  child: ListView(
                    children: [for (final userPreview in model.list) UserPreviewCard(userPreview)],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
