/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : user_bookmarks.dart
 */

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pixiv_xiaocao_android/api/entity/user_bookmarks/user_bookmarks_body.dart';
import 'package:pixiv_xiaocao_android/api/pixiv_request.dart';
import 'package:pixiv_xiaocao_android/component/image_view_from_url.dart';
import 'package:pixiv_xiaocao_android/pages/illust/illust.dart';
import 'package:pixiv_xiaocao_android/util.dart';

class UserBookmarksContent extends StatefulWidget {
  final int userId;

  UserBookmarksContent({required this.userId, Key? key}) : super(key: key);

  @override
  UserBookmarksContentState createState() => UserBookmarksContentState();
}

class UserBookmarksContentState extends State<UserBookmarksContent>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  UserBookmarksBody? _userBookmarksData;

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
  void dispose(){
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
          _userBookmarksData = null;
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

    final userBookmarks = await PixivRequest.instance.queryUserBookmarks(
      widget.userId,
      (_currentPage - 1) * _pageQuantity,
      _pageQuantity,
    );

    if (this.mounted) {
      if (userBookmarks != null) {
        if (!userBookmarks.error) {
          if (userBookmarks.body != null) {
            _hasNext =
                userBookmarks.body!.total > (_currentPage - 1) * _pageQuantity;
          }
          _userBookmarksData = userBookmarks.body;
        } else {
          print(userBookmarks.message);
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

  Widget _buildWorksGridView() {
    return StaggeredGridView.countBuilder(
      shrinkWrap: true,
      crossAxisCount: 2,
      itemCount: _userBookmarksData!.works.length,
      staggeredTileBuilder: (index) => StaggeredTile.fit(1),
      mainAxisSpacing: 6,
      crossAxisSpacing: 6,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return _userBookmarksData!.works[index].isMasked
            ? Card(
                child: ImageViewFromUrl(_userBookmarksData!.works[index].url),
              )
            : Card(
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    children: [
                      ImageViewFromUrl(
                        _userBookmarksData!.works[index].url,
                        fit: BoxFit.cover,
                        imageBuilder: (Widget imageWidget) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Util.gotoPage(
                                      context,
                                      IllustPage(
                                          _userBookmarksData!.works[index].id));
                                },
                                child: imageWidget,
                              ),
                              Positioned(
                                left: 2,
                                top: 2,
                                child: _userBookmarksData!.works[index].tags
                                        .contains('R-18')
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
                                      '${_userBookmarksData!.works[index].pageCount}',
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
                            '${_userBookmarksData!.works[index].title}',
                            style: TextStyle(fontSize: 14),
                          ),
                          subtitle: Text(
                              '${_userBookmarksData!.works[index].userName}',
                              style: TextStyle(fontSize: 10)),
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
    if (_userBookmarksData != null) {
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
                _loadData(reload: false);
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
