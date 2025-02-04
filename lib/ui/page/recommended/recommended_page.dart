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
import 'package:pixiv_func_android/ui/widget/lazy_indexed_stack.dart';
import 'package:pixiv_func_android/ui/widget/sliding_segmented_control.dart';
import 'package:pixiv_func_android/view_model/recommended_model.dart';

class RecommendedPage extends StatelessWidget {
  const RecommendedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      model: RecommendedModel(),
      builder: (BuildContext context, RecommendedModel model, Widget? child) {
        return Column(
          children: [
            SlidingSegmentedControl(
              children: const <WorkType, Widget>{
                WorkType.illust: Text('插画'),
                WorkType.manga: Text('漫画'),
                WorkType.novel: Text('小说'),
              },
              groupValue: model.type,
              onValueChanged: (WorkType? value) {
                if (null != value) {
                  model.type = value;
                }
              },
            ),
            Expanded(
              child: LazyIndexedStack(
                index: model.type.index,
                children: const [
                  RecommendedIllustContent(
                    WorkType.illust,
                  ),
                  RecommendedIllustContent(
                    WorkType.manga,
                  ),
                  RecommendedNovelContent(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
