/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:user_preview_card.dart
 * 创建时间:2021/8/29 下午11:42
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:pixiv_func_android/api/entity/user_preview.dart';
import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/ui/page/user/user_page.dart';
import 'package:pixiv_func_android/ui/widget/avatar_view_from_url.dart';
import 'package:pixiv_func_android/ui/widget/illust_previewer.dart';
import 'package:pixiv_func_android/util/page_utils.dart';
import 'package:pixiv_func_android/view_model/user_preview_model.dart';



class UserPreviewCard extends StatelessWidget {
  final UserPreview userPreview;

  const UserPreviewCard(this.userPreview, {Key? key}) : super(key: key);

  static const double padding = 3;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ProviderWidget(
        model: UserPreviewModel(userPreview),
        builder: (BuildContext context, UserPreviewModel model, Widget? child) {
          return Card(
            child: Column(
              children: [
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return Container(
                      width: constraints.maxWidth,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: model.userPreview.illusts
                            .map(
                              (illust) => Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(padding),
                                  child: IllustPreviewer(illust: illust, square: true),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: GestureDetector(
                    onTap: () => PageUtils.to(
                      context,
                      UserPage(
                        model.userPreview.user.id,
                        parentModel: model,
                      ),
                    ),
                    child: AvatarViewFromUrl(model.userPreview.user.profileImageUrls.medium),
                  ),
                  title: Text(model.userPreview.user.name),
                  trailing: model.followRequestWaiting
                      ? RefreshProgressIndicator()
                      : model.isFollowed
                          ? ElevatedButton(onPressed: model.onFollowStateChange, child: Text('已关注'))
                          : OutlinedButton(onPressed: model.onFollowStateChange, child: Text('关注')),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
