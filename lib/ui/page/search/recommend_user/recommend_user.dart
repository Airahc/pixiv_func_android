/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:recommend_user.dart
 * 创建时间:2021/9/2 下午2:18
 * 作者:小草
 */
import 'package:flutter/material.dart';
import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/ui/widget/refresher_widget.dart';
import 'package:pixiv_func_android/ui/widget/user_preview_card.dart';
import 'package:pixiv_func_android/view_model/recommend_user_model.dart';

class RecommendUser extends StatefulWidget {
  const RecommendUser({Key? key}) : super(key: key);

  @override
  _RecommendUserState createState() => _RecommendUserState();
}

class _RecommendUserState extends State<RecommendUser> {
  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      autoKeep: true,
      model: RecommendUserModel(),
      builder: (BuildContext context, RecommendUserModel model, Widget? child) {
        return RefresherWidget(
          model,
          child: ListView(
            children: model.list.map((e) => UserPreviewCard(e)).toList(),
          ),
        );
      },
    );
  }
}
