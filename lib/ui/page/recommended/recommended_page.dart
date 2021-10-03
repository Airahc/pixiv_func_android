/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:recommended_page.dart
 * 创建时间:2021/8/25 上午10:19
 * 作者:小草
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pixiv_func_android/api/enums.dart';
import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/ui/page/recommended/recommended_illust_content.dart';
import 'package:pixiv_func_android/ui/page/recommended/recommended_novel_content.dart';
import 'package:pixiv_func_android/view_model/recommended_model.dart';

class RecommendedPage extends StatelessWidget {
  const RecommendedPage({Key? key}) : super(key: key);

  final contents = const [
    RecommendedIllustContent(
      WorkType.illust,
      key: Key('RecommendedIllustContent(WorkType.illust)'),
    ),
    RecommendedIllustContent(
      WorkType.manga,
      key: Key('RecommendedIllustContent(WorkType.manga)'),
    ),
    RecommendedNovelContent(
      key: Key('RecommendedNovelContent()'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      model: RecommendedModel(),
      builder: (BuildContext context, RecommendedModel model, Widget? child) {
        return Column(
          children: [
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SizedBox(
                  width: constraints.maxWidth,
                  child: CupertinoSlidingSegmentedControl(
                    children: <WorkType, Widget>{
                      WorkType.illust: Container(
                        alignment: Alignment.center,
                        child: const Text('插画'),
                        width: constraints.maxWidth / 3,
                      ),
                      WorkType.manga: Container(
                        alignment: Alignment.center,
                        child: const Text('漫画'),
                        width: constraints.maxWidth / 3,
                      ),
                      WorkType.novel: Container(
                        alignment: Alignment.center,
                        child: const Text('小说'),
                        width: constraints.maxWidth / 3,
                      ),
                    },
                    groupValue: model.type,
                    onValueChanged: (WorkType? value) {
                      if (null != value) {
                        model.type = value;
                      }
                    },
                  ),
                );
              },
            ),
            Expanded(
              child: IndexedStack(
                index: model.type.index,
                children: contents,
              ),
            ),
          ],
        );
      },
    );
  }
}
