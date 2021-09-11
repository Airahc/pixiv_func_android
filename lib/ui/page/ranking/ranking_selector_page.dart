/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:ranking_selector_page.dart
 * 创建时间:2021/9/1 下午6:19
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/ui/page/ranking/ranking_page.dart';
import 'package:pixiv_func_android/util/page_utils.dart';
import 'package:pixiv_func_android/view_model/ranking_selector_model.dart';

class RankingSelectorPage extends StatelessWidget {
  const RankingSelectorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      model: RankingSelectorModel(),
      builder: (BuildContext context, RankingSelectorModel model, Widget? child) {
        return Column(
          children: [
            Container(
              padding: EdgeInsets.all(5),
              child: Wrap(
                spacing: 5,
                children: model.typeItems
                    .map((e) => ChoiceChip(
                  selectedColor: Theme.of(context).colorScheme.primary,
                  labelStyle:
                  TextStyle(fontSize: 15, color: !e.value ? Theme.of(context).colorScheme.primary : null),
                  label: Text(e.key.name),
                  selected: e.value,
                  onSelected: (bool value) => model.onSelected(e.key, value),
                ))
                    .toList(),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('选择你要查看的排行榜类型'),
                  SizedBox(width: 5),
                  Tooltip(
                    message: '减少不必要页面(数据)的加载 简单来说: 省流量',
                    child: Text(
                      '(?)',
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                ],
              ),
            ),
            OutlinedButton(
              onPressed: () => PageUtils.to(
                context,
                RankingPage(model.typeItems.where((e) => e.value).map((e) => e.key).toList()),
              ),
              child: Text('确定'),
            )
          ],
        );
      },
    );
  }
}
