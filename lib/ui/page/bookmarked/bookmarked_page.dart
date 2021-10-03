/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:bookmarked_page.dart
 * 创建时间:2021/8/29 上午10:33
 * 作者:小草
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/ui/widget/illust_previewer.dart';
import 'package:pixiv_func_android/ui/widget/refresher_widget.dart';
import 'package:pixiv_func_android/view_model/bookmarked_model.dart';

class BookmarkedPage extends StatelessWidget {
  const BookmarkedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      model: BookmarkedModel(),
      builder: (BuildContext context, BookmarkedModel model, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('收藏的作品'),
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
                  child: CustomScrollView(
                    slivers: [
                      SliverStaggeredGrid.countBuilder(
                        crossAxisCount: 2,
                        itemBuilder: (BuildContext context, int index) => IllustPreviewer(illust: model.list[index]),
                        staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
                        itemCount: model.list.length,
                      )
                    ],
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
