/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:novel_detail_dialog.dart
 * 创建时间:2021/10/3 下午9:36
 * 作者:小草
 */
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/ui/page/novel/novel_page.dart';
import 'package:pixiv_func_android/ui/widget/avatar_view_from_url.dart';
import 'package:pixiv_func_android/ui/widget/html_rich_text.dart';
import 'package:pixiv_func_android/util/page_utils.dart';
import 'package:pixiv_func_android/view_model/novel_detail_model.dart';
import 'package:pixiv_func_android/view_model/novel_previewer_model.dart';

class NovelDetailDialog extends StatelessWidget {
  final NovelPreviewerModel previewerModel;

  const NovelDetailDialog(this.previewerModel, {Key? key}) : super(key: key);

  final padding = const EdgeInsets.only(top: 10, bottom: 10);

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      model: NovelDetailModel(previewerModel),
      builder: (BuildContext context, NovelDetailModel model, Widget? child) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.background,
          contentPadding: const EdgeInsets.only(left: 5, right: 5),
          title: Padding(
            padding: padding,
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: AvatarViewFromUrl(model.novel.user.profileImageUrls.medium),
              title: Text(model.novel.user.name),
            ),
          ),
          content: SizedBox(
            width: window.physicalSize.width,
            height: window.physicalSize.height,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Divider(),
                  Padding(
                    padding: padding,
                    child: Text(model.novel.title),
                  ),
                  const Divider(),
                  Padding(
                    padding: padding,
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      runSpacing: 5,
                      spacing: 5,
                      children: [
                        for (final tag in model.novel.tags)
                          RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodyText2,
                              children: null != tag.translatedName
                                  ? [
                                      TextSpan(
                                        text: '#${tag.name}  ',
                                        style: TextStyle(color: Theme.of(context).colorScheme.primary),
                                      ),
                                      TextSpan(
                                        text: '${tag.translatedName}',
                                      ),
                                    ]
                                  : [
                                      TextSpan(
                                        text: '#${tag.name}',
                                        style: TextStyle(color: Theme.of(context).colorScheme.primary),
                                      ),
                                    ],
                            ),
                          )
                      ],
                    ),
                  ),
                  const Divider(),
                  Visibility(
                    visible: model.novel.caption.isNotEmpty,
                    child: Padding(
                      padding: padding,
                      child: InkWell(
                        onLongPress: () => model.showOriginalCaption = !model.showOriginalCaption,
                        child: Card(
                          child: Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.all(10),
                            child: HtmlRichText(
                              model.novel.caption,
                              showOriginal: model.showOriginalCaption,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            OutlinedButton(onPressed: () => PageUtils.back(context), child: const Text('关闭')),
            OutlinedButton(
                onPressed: () {
                  PageUtils.back(context);
                  PageUtils.to(
                    context,
                    NovelPage(
                      id: model.novel.id,
                    ),
                  );
                },
                child: const Text('阅读')),
            model.bookmarkRequestWaiting
                ? const RefreshProgressIndicator()
                : IconButton(
                    splashRadius: 20,
                    onPressed: model.bookmarkStateChange,
                    icon: model.isBookmarked
                        ? const Icon(
                            Icons.favorite_sharp,
                            color: Colors.pinkAccent,
                          )
                        : const Icon(
                            Icons.favorite_outline_sharp,
                          ),
                  ),
          ],
        );
      },
    );
  }
}
