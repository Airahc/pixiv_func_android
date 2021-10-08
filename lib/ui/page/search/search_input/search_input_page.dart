/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:search_input_page.dart
 * 创建时间:2021/9/3 下午4:14
 * 作者:小草
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pixiv_func_android/instance_setup.dart';

import 'package:pixiv_func_android/model/search_filter.dart';
import 'package:pixiv_func_android/model/search_image_result.dart';
import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/ui/page/illust/illust_page.dart';
import 'package:pixiv_func_android/ui/page/novel/novel_page.dart';
import 'package:pixiv_func_android/ui/page/search/search_filter_editor/search_filter_editor.dart';
import 'package:pixiv_func_android/ui/page/search/search_illust_result/search_illust_result_page.dart';
import 'package:pixiv_func_android/ui/page/search/search_image_result/search_image_result_page.dart';
import 'package:pixiv_func_android/ui/page/search/search_novel_result/search_novel_result_page.dart';
import 'package:pixiv_func_android/ui/page/search/search_user_result/search_user_result_page.dart';
import 'package:pixiv_func_android/ui/page/user/user_page.dart';
import 'package:pixiv_func_android/ui/widget/sliding_segmented_control.dart';
import 'package:pixiv_func_android/util/page_utils.dart';
import 'package:pixiv_func_android/view_model/search_input_model.dart';

class SearchInputPage extends StatelessWidget {
  const SearchInputPage({Key? key}) : super(key: key);

  Widget _buildSearchAutocomplete(BuildContext context, SearchInputModel model) {
    return ListView(
      children: [
        if (model.inputIsNumber)
          if (model.type == 0)
            ListTile(
              onTap: () => PageUtils.to(context, IllustPage(model.inputAsNumber)),
              title: Text('${model.inputAsNumber}'),
              subtitle: const Text('插画ID'),
            )
          else if (model.type == 1)
            ListTile(
              onTap: () => PageUtils.to(context, NovelPage(model.inputAsNumber)),
              title: Text('${model.inputAsNumber}'),
              subtitle: const Text('小说ID'),
            )
          else if (model.type == 2)
            ListTile(
              onTap: () => PageUtils.to(context, UserPage(model.inputAsNumber)),
              title: Text('${model.inputAsNumber}'),
              subtitle: const Text('用户ID'),
            ),
        if (null != model.searchAutocomplete)
          for (var tag in model.searchAutocomplete!.tags)
            ListTile(
              onTap: () => _toSearchResultPage(context, model, tag.name),
              title: Text(tag.name),
              subtitle: null != tag.translatedName ? Text(tag.translatedName!) : null,
            )
      ],
    );
  }

  Widget _buildInputBox(BuildContext context, SearchInputModel model) {
    return TextField(
      controller: model.wordInput,
      onSubmitted: (String value) => _toSearchResultPage(context, model, value),
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
        fillColor: Theme.of(context).backgroundColor,
        filled: true,
        hintText: '搜索关键字或ID',
        border: InputBorder.none,
        prefix: const SizedBox(width: 5),
        suffixIcon: model.inputAsString.isNotEmpty
            ? InkWell(
                onTap: () {
                  model.wordInput.clear();
                  model.searchAutocomplete = null;
                  model.cancelTask();
                },
                child: const Icon(
                  Icons.clear_outlined,
                  color: Colors.white54,
                ),
              )
            : null,
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

  void _toSearchResultPage(BuildContext context, SearchInputModel model, String word) {
    if (model.type == 0) {
      PageUtils.to(context, SearchIllustResultPage(word: word, filter: model.filter));
    } else if (model.type == 1) {
      PageUtils.to(context, SearchNovelResultPage(word: word, filter: model.filter));
    } else if (model.type == 2) {
      PageUtils.to(context, SearchUserResultPage(word));
    }
  }

  Widget _buildBody(BuildContext context, SearchInputModel model) {
    return Column(
      children: [
        SlidingSegmentedControl(
          children: const <int, Widget>{
            0: Text('插画&漫画'),
            1: Text('小说'),
            2: Text('用户'),
          },
          groupValue: model.type,
          onValueChanged: (int? value) {
            if (null != value) {
              model.type = value;
            }
          },
        ),
        Expanded(child: _buildSearchAutocomplete(context, model)),
      ],
    );
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
                icon: const Icon(Icons.filter_alt_outlined),
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
                        platformAPI.toast('搜索失败,或许可以重试');
                      },
                    ),
            child:
                model.searchImageWaiting ? const CircularProgressIndicator() : const Icon(Icons.image_search_outlined),
          ),
          body: _buildBody(context, model),
        );
      },
    );
  }
}
