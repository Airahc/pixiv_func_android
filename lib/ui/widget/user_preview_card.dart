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
import 'package:pixiv_func_android/ui/page/illust/illust_content_page.dart';
import 'package:pixiv_func_android/ui/page/user/user_page.dart';
import 'package:pixiv_func_android/util/page_utils.dart';
import 'package:pixiv_func_android/view_model/user_preview_model.dart';

import 'avatar_view_from_url.dart';
import 'image_view_from_url.dart';

class UserPreviewCard extends StatelessWidget {
  final UserPreview userPreview;

  const UserPreviewCard(this.userPreview, {Key? key}) : super(key: key);

  static const double padding = 5;

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
                    final width = constraints.maxWidth / 3 - padding * 2;
                    return Row(
                      children: model.userPreview.illusts
                          .map((illust) => Container(
                                padding: EdgeInsets.all(padding),
                                child: GestureDetector(
                                  onTap: () => PageUtils.to(context, IllustContentPage(illust)),
                                  child: ImageViewFromUrl(
                                    illust.imageUrls.squareMedium,
                                    width: width,
                                    height: width,
                                  ),
                                ),
                              ))
                          .toList(),
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
