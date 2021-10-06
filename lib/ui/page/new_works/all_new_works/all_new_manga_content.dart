/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:all_new_illust_content.dart
 * 创建时间:2021/10/4 下午8:37
 * 作者:小草
 */
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/ui/widget/illust_previewer.dart';
import 'package:pixiv_func_android/ui/widget/refresher_widget.dart';
import 'package:pixiv_func_android/view_model/all_new_manga_model.dart';

class AllNewMangaContent extends StatelessWidget {
  const AllNewMangaContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      model: AllNewMangaModel(),
      builder: (BuildContext context, AllNewMangaModel model, Widget? child) {
        return RefresherWidget(
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
        );
      },
    );
  }
}
