/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:search_image_result_item.dart
 * 创建时间:2021/9/7 下午6:25
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:pixiv_func_android/api/entity/illust.dart';
import 'package:pixiv_func_android/model/search_image_result.dart';
import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/provider/view_state.dart';
import 'package:pixiv_func_android/ui/page/illust/illust_content_page.dart';
import 'package:pixiv_func_android/ui/widget/image_view_from_url.dart';
import 'package:pixiv_func_android/util/page_utils.dart';
import 'package:pixiv_func_android/view_model/search_image_result_item_model.dart';

class SearchImageResultItem extends StatelessWidget {
  final SearchImageResult result;

  const SearchImageResultItem(this.result, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      model: SearchImageResultItemModel(result.illustId),
      builder: (BuildContext context, SearchImageResultItemModel model, Widget? child) {
        final Widget child;
        if (ViewState.InitFailed == model.viewState) {
          child = Center(
            child: ListTile(
              onTap: model.loadData,
              title: Center(
                child: Text('加载失败,点击重新加载'),
              ),
            ),
          );
        } else if (ViewState.Busy == model.viewState) {
          child = Center(child: CircularProgressIndicator());
        } else if (ViewState.Empty == model.viewState) {
          child = ListTile(
            title: Center(
              child: Text('插画ID:${result.illustId}不存在'),
            ),
          );
        } else {
          if (null == model.illust) {
            child = Container();
          } else {
            final Illust illust = model.illust!;
            child = ListTile(
              onTap: () => PageUtils.to(context, IllustContentPage(illust)),
              leading: ImageViewFromUrl(
                illust.imageUrls.squareMedium,
                width: 60,
                height: 60,
              ),
              title: Text('${illust.title}'),
              subtitle: Text('${illust.user.name}'),
              trailing: Text('相似度:${result.similarityText}'),
            );
          }
        }

        return Card(child: Container(height: 70, child: child));
      },
      onModelReady: (SearchImageResultItemModel model) => model.loadData(),
    );
  }
}
