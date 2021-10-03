/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:new_illust_page.dart
 * 创建时间:2021/8/29 下午12:02
 * 作者:小草
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pixiv_func_android/api/enums.dart';
import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/ui/widget/illust_previewer.dart';
import 'package:pixiv_func_android/view_model/new_illust_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NewIllustPage extends StatelessWidget {
  const NewIllustPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      model: NewIllustModel(),
      builder: (BuildContext context, NewIllustModel model, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('大家的新作品'),
          ),
          body: Column(
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
                          width: constraints.maxWidth / 2,
                        ),
                        WorkType.manga: Container(
                          alignment: Alignment.center,
                          child: const Text('漫画'),
                          width: constraints.maxWidth / 2,
                        ),
                        // WorkType.novel: Container(
                        //   alignment: Alignment.center,
                        //   child: const Text('小说'),
                        //   width: constraints.maxWidth / 2,
                        // ),
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
                child: SmartRefresher(
                  controller: model.refreshController,
                  enablePullDown: true,
                  enablePullUp: model.initialized && model.hasNext,
                  onRefresh: model.refreshRoutine,
                  onLoading: model.nextRoutine,
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
