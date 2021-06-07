/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : illust_many.dart
 */

import 'package:flutter/material.dart';
import 'package:pixiv_xiaocao_android/api/entity/illust_related/illust.dart';
import 'package:pixiv_xiaocao_android/api/pixiv_request.dart';
import 'package:pixiv_xiaocao_android/component/image_view_from_url.dart';
import 'package:pixiv_xiaocao_android/log/log_entity.dart';
import 'package:pixiv_xiaocao_android/log/log_util.dart';
import 'package:pixiv_xiaocao_android/pages/illust/illust_page.dart';
import 'package:pixiv_xiaocao_android/util.dart';

class IllustRelatedContent extends StatefulWidget {
  final int illustId;

  IllustRelatedContent(this.illustId);

  @override
  _IllustRelatedContentState createState() => _IllustRelatedContentState();
}

class _IllustRelatedContentState extends State<IllustRelatedContent> {
  final List<Illust> _illusts = <Illust>[];

  bool _loading = false;
  bool _initialize = false;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  Future _loadData({bool init = true}) async {
    if (this.mounted) {
      setState(() {
        if (init) {
          _initialize = false;
        }
        _loading = true;
      });
    } else {
      return;
    }

    var illustRelated = await PixivRequest.instance.getIllustRelated(
      widget.illustId,
      60,
      requestException: (e) {
        LogUtil.instance.add(
          type: LogType.NetworkException,
          id: widget.illustId,
          title: '获取插画相关推荐失败',
          url: '',
          context: '在插画页面',
          exception: e,
        );
      },
      decodeException: (e, response) {
        LogUtil.instance.add(
          type: LogType.DeserializationException,
          id: widget.illustId,
          title: '获取插画相关推荐反序列化异常',
          url: '',
          context: response,
          exception: e,
        );
      },
    );

    if (this.mounted && illustRelated != null) {
      if (!illustRelated.error) {
        if (illustRelated.body != null) {
          if (illustRelated.body!.illusts != null) {
            _illusts.addAll(illustRelated.body!.illusts!);
          }
        }
      } else {
        LogUtil.instance.add(
          type: LogType.Info,
          id: widget.illustId,
          title: '获取插画相关推荐失败',
          url: '',
          context: 'error:${illustRelated.message}',
        );
      }
    }
    if (this.mounted) {
      setState(() {
        if (init) {
          _initialize = true;
        }
        _loading = false;
      });
    }
  }

  Widget _buildImagesGridView() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: _illusts.map((illust) {
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Container(
              width: constraints.maxWidth,
              height: constraints.maxWidth,
              child: ImageViewFromUrl(
                illust.urlS,
                fit: BoxFit.cover,
                imageBuilder: (Widget imageWidget) {
                  return Center(
                    child: Stack(
                      children: [
                        GestureDetector(
                            onTap: () {
                              Util.gotoPage(
                                context,
                                IllustPage(illust.id),
                              );
                            },
                            child: imageWidget),
                        Positioned(
                          left: 2,
                          top: 2,
                          child: illust.tags.contains('R-18')
                              ? Card(
                                  color: Colors.pinkAccent,
                                  child: Text('R-18'),
                                )
                              : Container(),
                        ),
                        Positioned(
                          top: 2,
                          right: 2,
                          child: Card(
                            color: Colors.white12,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: Text('${illust.pageCount}'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_illusts.isNotEmpty) {
      return _buildImagesGridView();
    } else {
      if (_loading) {
        return Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else {
        if (_initialize) {
          return Container();
        } else {
          return ListTile(
            title: Center(
              child: Text('没有任何数据'),
            ),
          );
        }
      }
    }
  }
}
