/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:novel_previewer.dart
 * 创建时间:2021/10/3 下午2:20
 * 作者:小草
 */
import 'package:flutter/material.dart';
import 'package:pixiv_func_android/api/entity/novel.dart';
import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/ui/widget/image_view_from_url.dart';
import 'package:pixiv_func_android/ui/widget/novel_detail_dialog.dart';
import 'package:pixiv_func_android/view_model/novel_previewer_model.dart';

class NovelPreviewer extends StatelessWidget {
  final Novel novel;

  const NovelPreviewer(this.novel, {Key? key}) : super(key: key);

  Widget _buildBookmarkButton(NovelPreviewerModel model) {
    return IconButton(
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
    );
  }


  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      model: NovelPreviewerModel(novel),
      builder: (BuildContext context, NovelPreviewerModel model, Widget? child) {
        final sb = StringBuffer();
        final textCountString = model.novel.textLength.toString().replaceAllMapped(
          RegExp(r'\B(?=(?:\d{3})+\b)'),
          (match) {
            return ',${match.input.substring(match.start, match.end)}';
          },
        );
        sb.write('$textCountString字 ');
        for (final tag in model.novel.tags) {
          sb.write(' #${tag.name}');
        }
        return ListTile(
          contentPadding: const EdgeInsets.only(left: 5),
          onTap: () => showDialog(
            context: context,
            builder: (BuildContext context) => NovelDetailDialog(model),
          ),
          leading: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return SizedBox(
                width: constraints.maxWidth / 7,
                child: ImageViewFromUrl(model.novel.imageUrls.medium),
              );
            },
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: null != model.novel.series.title,
                child: Text('${model.novel.series.title}', style: Theme.of(context).textTheme.caption),
              ),
              Text(model.novel.title, style: Theme.of(context).textTheme.bodyText1),
              Text(
                'by ${model.novel.user.name}',
                style: Theme.of(context).textTheme.caption?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ],
          ),
          subtitle: Text(sb.toString()),
          trailing: model.bookmarkRequestWaiting ? const RefreshProgressIndicator() : _buildBookmarkButton(model),
        );
      },
    );
  }
}
