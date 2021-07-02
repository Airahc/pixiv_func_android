/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : search_input.dart
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pixiv_xiaocao_android/api/entity/search_autocomplete/search_autocomplete_body.dart';
import 'package:pixiv_xiaocao_android/api/pixiv_request.dart';
import 'package:pixiv_xiaocao_android/config/config_util.dart';
import 'package:pixiv_xiaocao_android/log/log_entity.dart';
import 'package:pixiv_xiaocao_android/log/log_util.dart';
import 'package:pixiv_xiaocao_android/pages/illust/illust_page.dart';
import 'package:pixiv_xiaocao_android/pages/search/search_by_image_page.dart';
import 'package:pixiv_xiaocao_android/pages/search/search_illust_result_page.dart';
import 'package:pixiv_xiaocao_android/pages/search/search_settings.dart';
import 'package:pixiv_xiaocao_android/pages/search/search_user_result_page.dart';
import 'package:pixiv_xiaocao_android/pages/user/user_page.dart';
import 'package:pixiv_xiaocao_android/utils.dart';

class SearchInputPage extends StatefulWidget {
  @override
  _SearchInputPageState createState() => _SearchInputPageState();
}

class _SearchInputPageState extends State<SearchInputPage> {
  SearchAutocompleteBody? _searchAutocompleteData;

  final _keywordInput = TextEditingController();

  var _lastInputTime = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _keywordInput.dispose();
    super.dispose();
  }

  int? get _inputNumber => int.tryParse(_keywordInput.text);

  Future _loadData() async {
    final searchAutocomplete =
        await PixivRequest.instance.getSearchAutocomplete(
      _keywordInput.text,
      requestException: (e) {
        LogUtil.instance.add(
          type: LogType.NetworkException,
          id: ConfigUtil.instance.config.currentAccount.userId,
          title: '获取搜索推荐失败',
          url: '',
          context: '在搜索输入页面',
          exception: e,
        );
      },
      decodeException: (e, response) {
        LogUtil.instance.add(
          type: LogType.NetworkException,
          id: ConfigUtil.instance.config.currentAccount.userId,
          title: '获取搜索推荐反序列化异常',
          url: '',
          context: response,
          exception: e,
        );
      },
    );
    if (searchAutocomplete != null) {
      setState(() {
        _searchAutocompleteData = searchAutocomplete.body;
      });
      if (searchAutocomplete.error) {
        LogUtil.instance.add(
          type: LogType.Info,
          id: ConfigUtil.instance.config.currentAccount.userId,
          title: '获取搜索推荐失败',
          url: '',
          context: 'error:${searchAutocomplete.message}',
        );
      }
    }
  }

  Widget _buildBody() {
    final inputNumber = _inputNumber;
    final list = <Widget>[];
    if(_keywordInput.text.isNotEmpty) {
      list.add(ListTile(
        onTap: () {
          Utils.gotoPage(context, SearchUserResultPage(_keywordInput.text));
        },
        title: Text(_keywordInput.text),
        subtitle: Text('搜索用户'),
      ));
    }
    if (inputNumber != null) {
      list.add(ListTile(
        onTap: () {
          Utils.gotoPage(
            context,
            IllustPage(inputNumber),
          );
        },
        title: Text('$inputNumber'),
        subtitle: Text('插画ID'),
      ));
      list.add(ListTile(
        onTap: () {
          Utils.gotoPage(context, UserPage(inputNumber));
        },
        title: Text('$inputNumber'),
        subtitle: Text('用户ID'),
      ));
    }
    _searchAutocompleteData?.candidates.forEach((candidate) {
      list.add(ListTile(
        onTap: () {
          Utils.gotoPage(context, SearchIllustResultPage(candidate.tagName));
        },
        title: Text('${candidate.tagName}'),
        subtitle: Text('访问数量:${candidate.accessCount}'),
      ));
    });

    return ListView(children: list);
  }

  void _waitAutocompleteKeyword() {
    Future.delayed(Duration(seconds: 1), () {
      if (DateTime.now().difference(_lastInputTime) > Duration(seconds: 1)) {
        _loadData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          color: Colors.white10,
          child: TextField(
            controller: _keywordInput,
            onChanged: (value) {
              if (value.isNotEmpty) {
                setState(() {});
                _lastInputTime = DateTime.now();
                _waitAutocompleteKeyword();
              } else {
                setState(() {
                  _searchAutocompleteData = null;
                });
              }
            },
            onSubmitted: (value) {
              Utils.gotoPage(context, SearchIllustResultPage(value));
            },
            decoration: InputDecoration(
              hintText: '搜索关键字或ID',
              border: InputBorder.none,
              prefix: SizedBox(width: 5),
              suffixIcon: InkWell(
                onTap: () {
                  setState(() {
                    _keywordInput.clear();
                    _searchAutocompleteData = null;
                  });
                },
                child: Icon(
                  Icons.close_sharp,
                  color: Colors.white54,
                ),
              ),
            ),
          ),
        ),
        actions: [
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                splashRadius: 20,
                icon: Icon(
                  Icons.settings,
                  color: Colors.white.withAlpha(220),
                ),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black.withAlpha(200),
        child: Icon(
          Icons.image_search_sharp,
          color: Colors.white,
        ),
        onPressed: () async {
          final ids = await Utils.searchIdsByImage();
          if (ids.isNotEmpty) {
            Utils.gotoPage(context, SearchByImagePage(ids));
          } else {
            LogUtil.instance.add(
              type: LogType.Info,
              id: 0,
              title: '搜索图片失败',
              url: '',
              context: '在搜索输入页面',
            );
          }
        },
      ),
      endDrawer: SearchSettings(),
      body: _buildBody(),
    );
  }
}
