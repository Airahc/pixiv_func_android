/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_android
 * 文件名称:search_input_page.dart
 * 创建时间:2021/9/3 下午4:14
 * 作者:小草
 */
import 'package:flutter/material.dart';
import 'package:pixiv_func_android/instance_setup.dart';

import 'package:pixiv_func_android/model/search_filter.dart';
import 'package:pixiv_func_android/model/search_image_result.dart';
import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/ui/page/illust/illust_page.dart';
import 'package:pixiv_func_android/ui/page/search/search_filter_editor/search_filter_editor.dart';
import 'package:pixiv_func_android/ui/page/search/search_illust_result/search_illust_result_page.dart';
import 'package:pixiv_func_android/ui/page/search/search_image_result/search_image_result_page.dart';
import 'package:pixiv_func_android/ui/page/search/search_user_result/search_user_result_page.dart';
import 'package:pixiv_func_android/ui/page/user/user_page.dart';
import 'package:pixiv_func_android/util/page_utils.dart';
import 'package:pixiv_func_android/view_model/search_input_model.dart';

class SearchInputPage extends StatelessWidget {
  const SearchInputPage({Key? key}) : super(key: key);

  Widget _buildBody(BuildContext context, SearchInputModel model) {
    final children = <Widget>[];
    if (model.inputAsString.isNotEmpty) {
      children.add(
        ListTile(
          onTap: () => PageUtils.to(context, SearchUserResultPage(model.inputAsString)),
          title: Text(model.inputAsString),
          subtitle: Text('搜索用户'),
        ),
      );
    }

    if (model.inputIsNumber) {
      children.addAll(
        [
          ListTile(
            onTap: () => PageUtils.to(context, IllustPage(model.inputAsNumber)),
            title: Text('${model.inputAsNumber}'),
            subtitle: Text('插画ID'),
          ),
          ListTile(
            onTap: () => PageUtils.to(context, UserPage(model.inputAsNumber)),
            title: Text('${model.inputAsNumber}'),
            subtitle: Text('用户ID'),
          )
        ],
      );
    }
    model.searchAutocomplete?.tags.forEach(
      (tag) {
        children.add(
          ListTile(
            onTap: () => _toSearchIllust(context, model, tag.name),
            title: Text(tag.name),
            subtitle: null != tag.translatedName ? Text(tag.translatedName!) : null,
          ),
        );
      },
    );

    return ListView(children: children);
  }

  Widget _buildInputBox(BuildContext context, SearchInputModel model) {
    return TextField(
      controller: model.wordInput,
      onSubmitted: (String value) => _toSearchIllust(context, model, value),
      onChanged: (value) {
        if (value.isNotEmpty) {
          model.lastInputTime = DateTime.now();
          model.startAutocomplete();
        } else {
          model.searchAutocomplete = null;
          model.cancelTask();
        }
      },
      decoration: InputDecoration(
        hintText: '搜索关键字或ID',
        border: InputBorder.none,
        prefix: SizedBox(width: 5),
        suffixIcon: InkWell(
          onTap: () {
            model.wordInput.clear();
            model.searchAutocomplete = null;
            model.cancelTask();
          },
          child: Icon(
            Icons.close_sharp,
            color: Colors.white54,
          ),
        ),
      ),
    );
  }

  void _openSearchFilterEditor(BuildContext context, SearchInputModel model) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SearchFilterEditor(
          filter: model.filter,
          onChanged: (SearchFilter value) => model.filter = value,
        );
      },
    );
  }

  void _toSearchIllust(BuildContext context, SearchInputModel model, String word) {
    PageUtils.to(context, SearchIllustResultPage(word: word, filter: model.filter));
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      model: SearchInputModel(),
      builder: (BuildContext context, SearchInputModel model, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: _buildInputBox(context, model),
            actions: [
              IconButton(
                tooltip: '打开搜索过滤编辑器',
                onPressed: () => _openSearchFilterEditor(context, model),
                icon: Icon(Icons.filter_alt_outlined),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.onBackground,
            onPressed: model.searchImageWaiting
                ? null
                : () => model.searchImage(
                      successCallback: (List<SearchImageResult> results) {
                        PageUtils.to(context, SearchImageResultPage(results));
                      },
                      errorCallback: (dynamic e) async {
                        await platformAPI.toast('搜索失败,或许可以重试');
                      },
                    ),
            child: model.searchImageWaiting ? CircularProgressIndicator() : Icon(Icons.image_search_outlined),
          ),
          body: _buildBody(context, model),
        );
      },
    );
  }
}
