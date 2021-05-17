/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : search_input.dart
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pixiv_xiaocao_android/api/entity/search_autocomplete/search_autocomplete_body.dart';
import 'package:pixiv_xiaocao_android/api/pixiv_request.dart';
import 'package:pixiv_xiaocao_android/pages/illust/illust.dart';
import 'package:pixiv_xiaocao_android/pages/search/search_content.dart';
import 'package:pixiv_xiaocao_android/pages/search/search_settings.dart';
import 'package:pixiv_xiaocao_android/pages/user/user.dart';
import 'package:pixiv_xiaocao_android/util.dart';

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
      decodeException: (e, response) {
        print(e);
      },
      requestException: (e) {
        print(e);
      },
    );
    if (searchAutocomplete != null) {
      setState(() {
        _searchAutocompleteData = searchAutocomplete.body;
      });
      if (searchAutocomplete.error) {
        print(searchAutocomplete.message);
      }
    }
  }

  Widget _buildBody() {
    final inputNumber = _inputNumber;
    final list = <Widget>[];
    if (inputNumber != null) {
      list.add(ListTile(
        onTap: () {
          Util.gotoPage(context, IllustPage(inputNumber));
        },
        title: Text('$inputNumber'),
        subtitle: Text('插画ID'),
      ));
      list.add(ListTile(
        onTap: () {
          Util.gotoPage(context, UserPage(inputNumber));
        },
        title: Text('$inputNumber'),
        subtitle: Text('用户ID'),
      ));
    }
    _searchAutocompleteData?.candidates.forEach((candidate) {
      list.add(ListTile(
        onTap: () {
          Util.gotoPage(context, SearchContentPage(candidate.tagName));
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
                if (_inputNumber != null) {
                  setState(() {});
                }
                _lastInputTime = DateTime.now();
                _waitAutocompleteKeyword();
              } else {
                setState(() {
                  _searchAutocompleteData = null;
                });
              }
            },
            onSubmitted: (value) {
              Util.gotoPage(context, SearchContentPage(value));
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
      endDrawer: SearchSettings(),
      body: _buildBody(),
    );
  }
}
