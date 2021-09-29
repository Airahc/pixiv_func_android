/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:search_image_result_page.dart
 * 创建时间:2021/9/7 下午6:21
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:pixiv_func_android/model/search_image_item.dart';
import 'package:pixiv_func_android/model/search_image_result.dart';
import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/ui/page/illust/illust_content_page.dart';
import 'package:pixiv_func_android/ui/widget/image_view_from_url.dart';
import 'package:pixiv_func_android/util/page_utils.dart';
import 'package:pixiv_func_android/view_model/search_image_result_model.dart';

class SearchImageResultPage extends StatelessWidget {
  final List<SearchImageResult> results;

  const SearchImageResultPage(this.results, {Key? key}) : super(key: key);

  Widget _buildItem(BuildContext context, SearchImageResultModel model, SearchImageItem item) {
    if (item.loadFailed) {
      return InkWell(
        onTap: () => model.loadData(item),
        child: const Card(
          child: SizedBox(
            height: 180,
            child: Center(
              child: Text('加载失败,点击重新加载'),
            ),
          ),
        ),
      );
    } else if (item.loading) {
      return const Card(
        child: SizedBox(
          height: 180,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    } else if (null == item.illust) {
      return Container();
    } else {
      final illust = item.illust!;
      return InkWell(
        onTap: () => PageUtils.to(context, IllustContentPage(illust)),
        child: Card(
          child: SizedBox(
            height: 180,
            child: Center(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return SizedBox(
                    width: constraints.maxWidth,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: ImageViewFromUrl(
                            illust.imageUrls.squareMedium,
                            width: 150,
                            height: 150,
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: Text(illust.title, overflow: TextOverflow.ellipsis),
                            subtitle: Text('相似度:${item.result.similarityText}'),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      model: SearchImageResultModel(results),
      builder: (BuildContext context, SearchImageResultModel model, Widget? child) {
        return Scaffold(
          appBar: AppBar(title: const Text('搜索图片')),
          body: ListView(
            children: [
              for (final result in model.list)
                _buildItem(
                  context,
                  model,
                  result,
                )
            ],
          ),
        );
      },
      onModelReady: (SearchImageResultModel model) => model.loadAll(),
    );
  }
}
