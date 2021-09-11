/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:trending_illust.dart
 * 创建时间:2021/9/2 下午2:17
 * 作者:小草
 */
import 'package:flutter/material.dart';
import 'package:pixiv_func_android/api/enums.dart';
import 'package:pixiv_func_android/api/model/trending_tags.dart';
import 'package:pixiv_func_android/model/search_filter.dart';
import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/ui/page/illust/illust_content_page.dart';
import 'package:pixiv_func_android/ui/page/search/search_illust_result/search_illust_result_page.dart';
import 'package:pixiv_func_android/ui/widget/image_view_from_url.dart';
import 'package:pixiv_func_android/ui/widget/refresher_widget.dart';
import 'package:pixiv_func_android/util/page_utils.dart';
import 'package:pixiv_func_android/view_model/trending_illust_model.dart';


class TrendingIllust extends StatefulWidget {
  const TrendingIllust({Key? key}) : super(key: key);

  @override
  _TrendingIllustState createState() => _TrendingIllustState();
}

class _TrendingIllustState extends State<TrendingIllust> {
  Widget _buildTagIllustItem(TrendTag trendTag) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          width: constraints.maxWidth,
          height: constraints.maxWidth,
          child: ImageViewFromUrl(
            trendTag.illust.imageUrls.squareMedium,
            color: Colors.white54,
            colorBlendMode: BlendMode.modulate,
            fit: BoxFit.fill,
            imageBuilder: (Widget imageWidget) {
              final children = <Widget>[
                Container(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Text(
                    '#${trendTag.tag}',
                    style: TextStyle(fontSize: 15),
                  ),
                )
              ];

              if (null != trendTag.translatedName) {
                children.add(
                  Container(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(
                      trendTag.translatedName!,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                );
              }
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  GestureDetector(
                    onTap: () => PageUtils.to(
                      context,
                      SearchIllustResultPage(
                        word: trendTag.tag,
                        filter: SearchFilter.create(target: SearchTarget.EXACT_MATCH_FOR_TAGS),
                      ),
                    ),
                    onLongPress: () => PageUtils.to(
                      context,
                      IllustContentPage(trendTag.illust),
                    ),
                    child: imageWidget,
                  ),
                  Positioned(bottom: 3, child: Column(children: children)),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      autoKeep: true,
      model: TrendingIllustModel(),
      builder: (BuildContext context, TrendingIllustModel model, Widget? child) {
        return RefresherWidget(
          model,
          child: CustomScrollView(
            slivers: [
              SliverGrid.count(
                crossAxisCount: 3,
                children: model.list.map((trendTag) => _buildTagIllustItem(trendTag)).toList(),
              )
            ],
          ),
        );
      },
    );
  }
}
