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
import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/ui/widget/illust_previewer.dart';
import 'package:pixiv_func_android/ui/widget/refresher_widget.dart';
import 'package:pixiv_func_android/view_model/following_new_illust_model.dart';

class FollowingNewIllustPage extends StatelessWidget {
  const FollowingNewIllustPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      model: FollowingNewIllustModel(),
      builder: (BuildContext context, FollowingNewIllustModel model, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('已经关注用户的新作品'),
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
                          child: const Text('全部'),
                          width: constraints.maxWidth / 3,
                        ),
                        1: Container(
                          alignment: Alignment.center,
                          child: const Text('公开'),
                          width: constraints.maxWidth / 3,
                        ),
                        2: Container(
                          alignment: Alignment.center,
                          child: const Text('私有'),
                          width: constraints.maxWidth / 3,
                        ),
                      },
                      groupValue: null == model.restrict
                          ? 0
                          : model.restrict!
                              ? 1
                              : 2,
                      onValueChanged: (int? value) {
                        if (null != value) {
                          model.restrict = [null, true, false][value];
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
