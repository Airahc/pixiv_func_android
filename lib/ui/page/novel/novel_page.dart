/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:novel_page.dart
 * 创建时间:2021/10/3 上午10:43
 * 作者:小草
 */
import 'package:flutter/material.dart';
import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/provider/view_state.dart';
import 'package:pixiv_func_android/ui/widget/html_rich_text.dart';
import 'package:pixiv_func_android/ui/widget/image_view_from_url.dart';
import 'package:pixiv_func_android/util/page_utils.dart';
import 'package:pixiv_func_android/view_model/novel_model.dart';

class NovelPage extends StatelessWidget {
  final int id;
  final int page;

  const NovelPage({
    Key? key,
    required this.id,
    this.page = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      model: NovelModel(id),
      builder: (BuildContext context, NovelModel model, Widget? child) {
        final Widget widget;
        if (ViewState.initFailed == model.viewState) {
          widget = Center(
            child: ListTile(
              onTap: model.loadData,
              title: const Center(
                child: Text('加载失败,点击重新加载'),
              ),
            ),
          );
        } else if (ViewState.empty == model.viewState) {
          widget = const Center(
            child: Text('没有任何数据'),
          );
        } else {
          final novelJSData = model.novelJSData;
          if (null != novelJSData) {
            widget = CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: ImageViewFromUrl(novelJSData.coverUrl),
                ),
                SliverToBoxAdapter(
                  child: HtmlRichText(novelJSData.text),
                ),
                SliverToBoxAdapter(
                  child: Visibility(
                    visible: null != novelJSData.seriesNavigation?.prevNovel,
                    child: ListTile(
                      onTap: () => PageUtils.back(context),
                      title: const Text('上一页'),
                      subtitle: Text('${novelJSData.seriesNavigation?.prevNovel?.title}'),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Visibility(
                    visible: null != novelJSData.seriesNavigation?.nextNovel,
                    child: ListTile(
                      onTap: () => PageUtils.to(
                        context,
                        NovelPage(
                          id: novelJSData.seriesNavigation!.nextNovel!.id,
                          page: page + 1,
                        ),
                      ),
                      title: const Text('下一页'),
                      subtitle: Text('${novelJSData.seriesNavigation?.nextNovel?.title}'),
                    ),
                  ),
                ),
              ],
            );
          } else {
            widget = const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
        return Scaffold(
          appBar: AppBar(
            title: Text('小说 第${page+1}页'),
          ),
          body: widget,
        );
      },
      onModelReady: (NovelModel model) => model.loadData(),
    );
  }
}
