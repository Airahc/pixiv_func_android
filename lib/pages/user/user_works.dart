/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : user_works.dart
 */

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pixiv_xiaocao_android/api/entity/user_works/bookmark_data.dart';
import 'package:pixiv_xiaocao_android/api/entity/user_works/work.dart';
import 'package:pixiv_xiaocao_android/api/pixiv_request.dart';
import 'package:pixiv_xiaocao_android/component/bookmark_add_dialog_content.dart';
import 'package:pixiv_xiaocao_android/component/image_view_from_url.dart';
import 'package:pixiv_xiaocao_android/pages/illust/illust.dart';
import 'package:pixiv_xiaocao_android/util.dart';

enum UserWorkType { illust, manga }

class UserWorksContent extends StatefulWidget {
  final UserWorkType type;
  final int userId;

  UserWorksContent({required this.type, required this.userId, Key? key})
      : super(key: key);

  @override
  UserWorksContentState createState() => UserWorksContentState();
}

class UserWorksContentState extends State<UserWorksContent>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<int> _ids = <int>[];

  List<Work> _works = <Work>[];

  final _scrollController = ScrollController();

  static const int _pageQuantity = 30;

  int _currentPage = 1;

  bool _hasNext = true;
  bool _loading = false;

  bool _initialize = false;

  @override
  void initState() {
    _loadData(reload: false, init: true);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void scrollToTop() {
    if (_scrollController.hasClients) {
      if (_scrollController.offset != 0) {
        _scrollController.animateTo(
          0,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInQuad,
        );
      }
    }
  }

  Future _loadData({bool reload = true, bool init = false}) async {
    if (this.mounted) {
      setState(() {
        if (reload) {
          _ids.clear();
          _works.clear();
          _currentPage = 1;
          _hasNext = true;
        }
        if (init) {
          _initialize = false;
        }
        _loading = true;
      });
    } else {
      return;
    }

    final userAllWork = await PixivRequest.instance.getUserAllWork(
      widget.userId,
      decodeException: (e, response) {
        print(e);
      },
      requestException: (e) {
        print(e);
      },
    );

    if (this.mounted) {
      if (userAllWork != null) {
        if (!userAllWork.error) {
          if (userAllWork.body != null) {
            _hasNext = _ids.length > _pageQuantity;
            switch (widget.type) {
              case UserWorkType.illust:
                _ids.addAll(userAllWork.body!.illusts);
                break;
              case UserWorkType.manga:
                _ids.addAll(userAllWork.body!.manga);
                break;
            }
            await _loadWorkData();
          }
        } else {
          print(userAllWork.message);
        }
      }
    } else {
      return;
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

  Future _loadWorkData() async {
    if (this.mounted) {
      setState(() {
        _loading = true;
      });
    } else {
      return;
    }
    final startOffset = ((_currentPage - 1) * _pageQuantity);

    final endOffset = _ids.length >= startOffset + _pageQuantity
        ? startOffset + _pageQuantity
        : _ids.length;

    _hasNext = _ids.length >= startOffset + _pageQuantity;

    final works = await PixivRequest.instance.queryWorksById(
      _ids.getRange(startOffset, endOffset).toList(),
      false,
      decodeException: (e, response) {
        print(e);
      },
      requestException: (e) {
        print(e);
      },
    );
    if (this.mounted) {
      if (works != null) {
        if (!works.error) {
          if (works.body != null) {
            setState(() {
              _works.addAll(works.body!.works.values);
            });
          }
        } else {
          print(works.message);
        }
      }
    } else {
      return;
    }

    if (this.mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  Widget? _buildBookmarkButton({
    required int illustId,
    required int? bookmarkId,
    required void Function(int? bookmarkId) updateCallback,
  }) {
    return IconButton(
      splashRadius: 20,
      onPressed: () async {
        if (bookmarkId != null) {
          var success = await PixivRequest.instance.bookmarkDelete(bookmarkId);
          if (!success) {
            print('删除书签失败');
          }
          if (this.mounted) {
            if (success) {
              setState(() {
                updateCallback.call(null);
              });
            }
          }
        } else {
          showDialog<Null>(
            context: context,
            builder: (context) {
              return BookmarkAddDialogContent(
                illustId,
                (bool success, int? bookmarkId) {
                  if (success) {
                    if (bookmarkId != null) {
                      if (this.mounted) {
                        updateCallback.call(bookmarkId);
                      }
                    }
                  } else {
                    print('添加书签失败');
                  }
                },
              );
            },
          );
        }
      },
      icon: Icon(
        bookmarkId != null
            ? Icons.favorite_sharp
            : Icons.favorite_outline_sharp,
        color: bookmarkId != null ? Colors.pinkAccent : Colors.white70,
      ),
    );
  }

  Widget _buildWorksGridView() {
    return StaggeredGridView.countBuilder(
      shrinkWrap: true,
      crossAxisCount: 2,
      itemCount: _works.length,
      staggeredTileBuilder: (index) => StaggeredTile.fit(1),
      mainAxisSpacing: 6,
      crossAxisSpacing: 6,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: Container(
            padding: EdgeInsets.all(5),
            child: Column(
              children: [
                ImageViewFromUrl(
                  _works[index].url,
                  fit: BoxFit.cover,
                  imageBuilder: (Widget imageWidget) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Util.gotoPage(
                                context, IllustPage(_works[index].id));
                          },
                          child: imageWidget,
                        ),
                        Positioned(
                          left: 2,
                          top: 2,
                          child: _works[index].tags.contains('R-18')
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
                              child: Text(
                                '${_works[index].pageCount}',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(0),
                    title: Text(
                      '${_works[index].title}',
                      style: TextStyle(fontSize: 14),
                    ),
                    subtitle: Text(
                        Util.dateTimeToString(_works[index].updateDate),
                        style: TextStyle(fontSize: 10)),
                    trailing: _buildBookmarkButton(
                      illustId: _works[index].id,
                      bookmarkId: _works[index].bookmarkData?.id,
                      updateCallback: (int? bookmarkId) {
                        setState(() {
                          if (bookmarkId == null) {
                            _works[index].bookmarkData = null;
                          } else {
                            _works[index].bookmarkData =
                                BookmarkData(bookmarkId, false);
                          }
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    late Widget component;
    if (_works.isNotEmpty) {
      final List<Widget> list = [];
      list.add(_buildWorksGridView());
      if (_loading) {
        list.add(SizedBox(height: 20));
        list.add(Center(
          child: CircularProgressIndicator(),
        ));
        list.add(SizedBox(height: 20));
      } else {
        if (_hasNext) {
          list.add(Card(
            child: ListTile(
              title: Text('加载更多'),
              onTap: () {
                _currentPage++;
                _loadWorkData();
              },
            ),
          ));
        } else {
          list.add(Card(child: ListTile(title: Text('没有更多数据啦'))));
        }
      }

      component = SingleChildScrollView(
        controller: _scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: list,
        ),
      );
    } else {
      if (_loading) {
        if (!_initialize) {
          component = Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          component = Container();
        }
      } else {
        component = ListView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Center(
                child: Text('没有任何数据'),
              ),
            );
          },
          physics: const AlwaysScrollableScrollPhysics(),
        );
      }
    }

    return component;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      child: _buildBody(),
      onRefresh: _loadData,
      backgroundColor: Colors.white,
    );
  }
}
