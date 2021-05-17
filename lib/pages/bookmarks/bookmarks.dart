/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : bookmarks.dart
 */

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pixiv_xiaocao_android/api/entity/bookmarks/bookmark.dart';
import 'package:pixiv_xiaocao_android/api/pixiv_request.dart';
import 'package:pixiv_xiaocao_android/component/bookmark_add_dialog_content.dart';
import 'package:pixiv_xiaocao_android/component/image_view_from_url.dart';
import 'package:pixiv_xiaocao_android/config.dart';
import 'package:pixiv_xiaocao_android/pages/illust/illust.dart';
import 'package:pixiv_xiaocao_android/util.dart';

class BookmarksPage extends StatefulWidget {
  @override
  _BookmarksPageState createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  List<Bookmark> _bookmarks = <Bookmark>[];

  ScrollController _scrollController = ScrollController();

  int _currentPage = 1;

  bool _hasNext = true;
  bool _loading = false;

  bool _initialize = false;

  @override
  void initState() {
    _loadData(reload: false, init: true);
    super.initState();
  }

  Future _loadData({bool reload = true, bool init = false}) async {
    if (this.mounted) {
      setState(() {
        if (reload) {
          _bookmarks.clear();
          _currentPage = 1;
        }
        if (init) {
          _initialize = false;
        }
        _loading = true;
      });
    } else {
      return;
    }

    final bookmarks =
        await PixivRequest.instance.getBookmarks(Config.userId, _currentPage);
    if (this.mounted) {
      if (bookmarks != null) {
        if (!bookmarks.error) {
          setState(() {
            _hasNext = bookmarks.body!.lastPage != _currentPage;
            _bookmarks.addAll(bookmarks.body!.bookmarks);
          });
        } else {
          print(bookmarks.message);
        }
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
      itemCount: _bookmarks.length,
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
                  _bookmarks[index].urlS,
                  fit: BoxFit.cover,
                  imageBuilder: (Widget imageWidget) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Util.gotoPage(
                                context, IllustPage(_bookmarks[index].id));
                          },
                          child: imageWidget,
                        ),
                        Positioned(
                          left: 2,
                          top: 2,
                          child: _bookmarks[index].tags.contains('R-18')
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
                              child: Text('${_bookmarks[index].pageCount}'),
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
                      '${_bookmarks[index].title}',
                      style: TextStyle(fontSize: 14),
                    ),
                    subtitle: Text(
                      '${_bookmarks[index].authorDetails.userName}',
                      style: TextStyle(fontSize: 10),
                    ),
                    // leading: AvatarViewFromUrl,
                    trailing: _buildBookmarkButton(
                      illustId: _bookmarks[index].id,
                      bookmarkId: _bookmarks[index].bookmarkId,
                      updateCallback: (int? bookmarkId) {
                        setState(() {
                          if (bookmarkId == null) {
                            _bookmarks[index].bookmarkId = null;
                          } else {
                            _bookmarks[index].bookmarkId = bookmarkId;
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
    if (_bookmarks.isNotEmpty) {
      final List<Widget> list = [];
      list.add(_buildWorksGridView());

      if (_bookmarks.isNotEmpty) {
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
                  _loadData(reload: false);
                },
              ),
            ));
          } else {
            list.add(Card(child: ListTile(title: Text('没有更多数据啦'))));
          }
        }
      }
      component = SingleChildScrollView(
        controller: _scrollController,
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
    return Scaffold(
      appBar: AppBar(
        title: Text('已收藏的书签'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: _buildBody(),
        backgroundColor: Colors.white,
      ),
    );
  }
}
