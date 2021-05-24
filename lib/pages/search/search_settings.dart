/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : search_settings.dart
 */

import 'package:flutter/material.dart';
import 'package:pixiv_xiaocao_android/component/segment_bar.dart';

class SearchSettings extends StatefulWidget {
  static const searchModeItems = <MapEntry<String, String>>[
    MapEntry('标签', 's_tag'),
    MapEntry('标签(完全一致)', 's_tag_full'),
    MapEntry('标签·简介', 's_tc'),
    MapEntry('标签·简介·内容', 's_tag_tc'),
  ];

  static late String searchModeSelected = searchModeItems.first.value;

  static const workTypeItems = <MapEntry<String, String>>[
    MapEntry('全部', 'all'),
    MapEntry('插画', 'illust'),
    MapEntry('漫画', 'manga'),
    MapEntry('动图', 'ugoira'),
  ];

  static late String workTypeSelected = workTypeItems.first.value;

  static const ageLimitItems = <MapEntry<String, String>>[
    MapEntry('全年龄&R-18', 'all'),
    MapEntry('全年龄', 'safe'),
    MapEntry('R-18', 'r18'),
  ];

  static late String ageLimitSelected = ageLimitItems.first.value;

  static late var currentDateTime = DateTime.now().toUtc();

  static final firstDate = DateTime(
      currentDateTime.year, currentDateTime.month, currentDateTime.day);

  static final lastDate = DateTime(
      currentDateTime.year - 1, currentDateTime.month, currentDateTime.day);

  static late var startDate = lastDate;
  static late var endDate = firstDate;

  static bool dateLimitChecked = false;

  static final includeKeywords = <String>[];
  static final notIncludeKeywords = <String>[];

  static String dateToString(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  @override
  _SearchSettingsState createState() => _SearchSettingsState();
}

class _SearchSettingsState extends State<SearchSettings> {
  final _includeKeywordInput = TextEditingController();
  final _notIncludeKeywordInput = TextEditingController();

  @override
  void dispose() {
    _includeKeywordInput.dispose();
    _notIncludeKeywordInput.dispose();
    super.dispose();
  }

  Widget _buildBody() {
    final list = <Widget>[];
    list.add(SizedBox(height: 50));
    list.add(Card(
      child: Container(
        child: Column(
          children: [
            ListTile(
                title: Center(
              child: Text('搜索方式'),
            )),
            SegmentBarView(
              items: SearchSettings.searchModeItems.map((e) => e.key).toList(),
              values:
                  SearchSettings.searchModeItems.map((e) => e.value).toList(),
              onSelected: (String value) {
                setState(() {
                  SearchSettings.searchModeSelected = value;
                });
              },
              selectedValue: SearchSettings.searchModeSelected,
            )
          ],
        ),
      ),
    ));
    list.add(SizedBox(height: 10));
    list.add(Card(
      child: Container(
        child: Column(
          children: [
            ListTile(
                title: Center(
              child: Text('作品类型'),
            )),
            SegmentBarView(
              items: SearchSettings.workTypeItems.map((e) => e.key).toList(),
              values: SearchSettings.workTypeItems.map((e) => e.value).toList(),
              onSelected: (String value) {
                setState(() {
                  SearchSettings.workTypeSelected = value;
                });
              },
              selectedValue: SearchSettings.workTypeSelected,
            )
          ],
        ),
      ),
    ));
    list.add(SizedBox(height: 10));
    list.add(Card(
      child: Container(
        child: Column(
          children: [
            ListTile(
                title: Center(
              child: Text('年龄限制'),
            )),
            SegmentBarView(
              items: SearchSettings.ageLimitItems.map((e) => e.key).toList(),
              values: SearchSettings.ageLimitItems.map((e) => e.value).toList(),
              onSelected: (String value) {
                setState(() {
                  SearchSettings.ageLimitSelected = value;
                });
              },
              selectedValue: SearchSettings.ageLimitSelected,
            )
          ],
        ),
      ),
    ));
    list.add(SizedBox(height: 10));
    list.add(Card(
      child: Container(
        child: Column(
          children: [
            CheckboxListTile(
                value: SearchSettings.dateLimitChecked,
                onChanged: (value) {
                  if (value != null)
                    setState(() {
                      SearchSettings.dateLimitChecked = value;
                    });
                },
                title: Center(
                  child: Text('日期限制'),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    showDatePicker(
                            context: context,
                            firstDate: SearchSettings.lastDate,
                            lastDate: SearchSettings.firstDate,
                            initialDate: SearchSettings.startDate)
                        .then((date) {
                      if (date != null)
                        setState(() {
                          SearchSettings.startDate = date;
                        });
                    });
                  },
                  child: Text(
                      SearchSettings.dateToString(SearchSettings.startDate)),
                ),
                SizedBox(
                  width: 10,
                ),
                Text('-'),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    showDatePicker(
                      context: context,
                      firstDate: SearchSettings.lastDate,
                      lastDate: SearchSettings.firstDate,
                      initialDate: SearchSettings.endDate,
                    ).then((date) {
                      if (date != null)
                        setState(() {
                          SearchSettings.endDate = date;
                        });
                    });
                  },
                  child:
                      Text(SearchSettings.dateToString(SearchSettings.endDate)),
                )
              ],
            ),
            SizedBox(height: 10)
          ],
        ),
      ),
    ));

    list.add(SizedBox(height: 10));

    list.add(Card(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
                title: Center(
              child: Text('包含关键字'),
            )),
            Container(
              color: Colors.white10,
              child: TextField(
                controller: _includeKeywordInput,
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      SearchSettings.includeKeywords.add(value);
                      _includeKeywordInput.clear();
                    });
                  }
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: InkWell(
                    child: Icon(
                      Icons.delete_forever,
                    ),
                    onTap: () {
                      setState(() {
                        SearchSettings.includeKeywords.clear();
                      });
                    },
                  ),
                  suffixIcon: InkWell(
                    child: Icon(Icons.add_sharp),
                    onTap: () {
                      setState(() {
                        if (_includeKeywordInput.text.isNotEmpty) {
                          SearchSettings.includeKeywords
                              .add(_includeKeywordInput.text);
                          _includeKeywordInput.clear();
                        }
                      });
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 5,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: SearchSettings.includeKeywords
                  .map((keyword) => Container(
                          child: Stack(children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.pinkAccent),
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 5, 15, 5),
                            child: Text(keyword),
                          ),
                        ),
                        Positioned(
                          right: 2,
                          top: 2,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                SearchSettings.includeKeywords.remove(keyword);
                              });
                            },
                            child: Icon(Icons.close_sharp, size: 15),
                          ),
                        )
                      ])))
                  .toList(),
            ),
          ],
        ),
      ),
    ));

    list.add(SizedBox(height: 10));

    list.add(Card(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
                title: Center(
              child: Text('不包含关键字'),
            )),
            Container(
              color: Colors.white10,
              child: TextField(
                controller: _notIncludeKeywordInput,
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      SearchSettings.notIncludeKeywords.add(value);
                      _notIncludeKeywordInput.clear();
                    });
                  }
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: InkWell(
                    child: Icon(
                      Icons.delete_forever,
                    ),
                    onTap: () {
                      setState(() {
                        SearchSettings.notIncludeKeywords.clear();
                      });
                    },
                  ),
                  suffixIcon: InkWell(
                    child: Icon(Icons.add_sharp),
                    onTap: () {
                      if (_notIncludeKeywordInput.text.isNotEmpty) {
                        setState(() {
                          SearchSettings.notIncludeKeywords
                              .add(_notIncludeKeywordInput.text);
                          _notIncludeKeywordInput.clear();
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 5,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: SearchSettings.notIncludeKeywords
                  .map((keyword) => Container(
                          child: Stack(children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.pinkAccent),
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 5, 15, 5),
                            child: Text(keyword),
                          ),
                        ),
                        Positioned(
                          right: 2,
                          top: 2,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                SearchSettings.notIncludeKeywords
                                    .remove(keyword);
                              });
                            },
                            child: Icon(Icons.close_sharp, size: 15),
                          ),
                        )
                      ])))
                  .toList(),
            ),
          ],
        ),
      ),
    ));

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: list,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(child: _buildBody());
  }
}
