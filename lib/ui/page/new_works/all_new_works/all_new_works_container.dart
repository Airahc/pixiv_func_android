/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:all_new_works_container.dart
 * 创建时间:2021/10/4 下午8:37
 * 作者:小草
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/ui/page/new_works/all_new_works/all_new_illust_content.dart';
import 'package:pixiv_func_android/ui/page/new_works/all_new_works/all_new_manga_content.dart';
import 'package:pixiv_func_android/ui/page/new_works/all_new_works/all_new_novel_content.dart';
import 'package:pixiv_func_android/ui/widget/lazy_indexed_stack.dart';
import 'package:pixiv_func_android/view_model/all_new_works_model.dart';

class AllNewWorksContainer extends StatelessWidget {
  const AllNewWorksContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      model: AllNewWorksModel(),
      builder: (BuildContext context, AllNewWorksModel model, Widget? child) {
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: CupertinoSegmentedControl(
                    children: const <int, Widget>{
                      0: Padding(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: Text('插画'),
                      ),
                      1: Padding(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: Text('漫画'),
                      ),
                      2: Padding(
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
                Expanded(
                  child: LazyIndexedStack(
                    index: model.index,
                    children: const [
                      AllNewIllustContent(),
                      AllNewMangaContent(),
                      AllNewNovelContent(),
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
