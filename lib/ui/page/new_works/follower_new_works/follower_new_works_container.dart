/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:follower_new_works_container.dart
 * 创建时间:2021/10/4 下午8:35
 * 作者:小草
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/ui/page/new_works/follower_new_works/follower_new_illust_content.dart';
import 'package:pixiv_func_android/ui/page/new_works/follower_new_works/follower_new_novel_content.dart';
import 'package:pixiv_func_android/ui/widget/lazy_indexed_stack.dart';
import 'package:pixiv_func_android/view_model/follower_new_works_model.dart';

class FollowerNewWorksContainer extends StatelessWidget {
  const FollowerNewWorksContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      model: FollowerNewWorksModel(),
      builder: (BuildContext context, FollowerNewWorksModel model, Widget? child) {
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Column(
              children: [
                SizedBox(
                  height: 28,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        alignment: Alignment.topCenter,
                        child: CupertinoSegmentedControl(
                          children: const <int, Widget>{
                            0: Padding(
                              padding: EdgeInsets.only(left: 15, right: 15),
                              child: Text('插画·漫画'),
                            ),
                            1: Padding(
                              padding: EdgeInsets.only(left: 15, right: 15),
                              child: Text('小说'),
                            ),
                          },
                          groupValue: model.index,
                          onValueChanged: (int? value) {
                            if (null != value) {
                              model.index = value;
                            }
                          },
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 15,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<bool?>(
                            items: [
                              for (final item in model.restrictItems)
                                DropdownMenuItem(
                                  value: item.key,
                                  child: Text(
                                    item.value,
                                    style: item.key == model.restrict
                                        ? TextStyle(color: Theme.of(context).colorScheme.primary)
                                        : null,
                                  ),
                                )
                            ],
                            value: model.restrict,
                            onChanged: (bool? value) {
                              model.restrict = value;
                            },
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: LazyIndexedStack(
                    key: Key('LazyIndexedStack:${model.restrict.hashCode}-FollowerNewWorksContainer'),
                    index: model.index,
                    children: [
                      FollowerNewIllustContent(model.restrict),
                      FollowerNewNovelContent(model.restrict),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
