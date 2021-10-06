/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:new_works_page.dart
 * 创建时间:2021/10/5 下午12:07
 * 作者:小草
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/ui/page/new_works/all_new_works/all_new_works_container.dart';
import 'package:pixiv_func_android/ui/page/new_works/follower_new_works/follower_new_works_container.dart';
import 'package:pixiv_func_android/ui/widget/lazy_indexed_stack.dart';
import 'package:pixiv_func_android/view_model/new_works_model.dart';

class NewWorksPage extends StatelessWidget {
  const NewWorksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      model: NewWorksModel(),
      builder: (BuildContext context, NewWorksModel model, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('最新'),
          ),
          body: Column(
            children: [
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return SizedBox(
                    width: constraints.maxWidth,
                    child: CupertinoSlidingSegmentedControl(
                      children: <int, Widget>{
                        0: Container(
                          alignment: Alignment.center,
                          child: const Text('关注者'),
                          width: constraints.maxWidth / 2,
                        ),
                        1: Container(
                          alignment: Alignment.center,
                          child: const Text('所有人'),
                          width: constraints.maxWidth / 2,
                        ),
                      },
                      groupValue: model.index,
                      onValueChanged: (int? value) {
                        if (null != value) {
                          model.index = value;
                        }
                      },
                    ),
                  );
                },
              ),
              Expanded(
                child: LazyIndexedStack(
                  index: model.index,
                  children: const [
                    FollowerNewWorksContainer(),
                    AllNewWorksContainer(),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
