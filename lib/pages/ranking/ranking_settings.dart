/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : ranking_settings.dart
 */

import 'package:flutter/material.dart';
import 'package:pixiv_xiaocao_android/component/segment_bar.dart';

class RankingSettings extends StatefulWidget {
  static final typeItems = <MapEntry<String, String>>[
    MapEntry('全部', 'all'),
    MapEntry('插画', 'illust'),
    MapEntry('漫画', 'manga'),
  ];

  static String typeSelected = typeItems.first.value;

  static List<MapEntry<String, String>> get modeItems {
    if (typeSelected == 'all') {
      return <MapEntry<String, String>>[
        MapEntry('　每日　', 'daily'),
        MapEntry('　本周　', 'weekly'),
        MapEntry('　本月　', 'monthly'),
        MapEntry('　新人　', 'rookie'),
        MapEntry('　原创　', 'original'),
        MapEntry('男性欢迎', 'male'),
        MapEntry('女性欢迎', 'female'),
      ];
    } else {
      return <MapEntry<String, String>>[
        MapEntry('　每日　', 'daily'),
        MapEntry('　本周　', 'weekly'),
        MapEntry('　本月　', 'monthly'),
        MapEntry('　新人　', 'rookie'),
      ];
    }
  }

  static List<MapEntry<String, String>> get modeR18Items {
    if (typeSelected == 'all') {
      return <MapEntry<String, String>>[
        MapEntry('　每日　', 'daily_r18'),
        MapEntry('　本周　', 'weekly_r18'),
        MapEntry('男性欢迎', 'male_r18'),
        MapEntry('女性欢迎', 'female_r18'),
      ];
    } else {
      return <MapEntry<String, String>>[
        MapEntry('　每日　', 'daily_r18'),
        MapEntry('　本周　', 'weekly_r18'),
      ];
    }
  }

  static String modeSelected = modeItems.first.value;

  static String modeR18Selected = modeR18Items.first.value;

  static bool isR18 = false;

  @override
  _RankingSettingsState createState() => _RankingSettingsState();
}

class _RankingSettingsState extends State<RankingSettings> {
  Widget _buildBody() {
    final list = <Widget>[];
    list.add(SizedBox(height: 50));
    list.add(Card(
      child: Container(
        child: CheckboxListTile(
          title: Text('R-18'),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                RankingSettings.isR18 = value;
              });
            }
          },
          value: RankingSettings.isR18,
        ),
      ),
    ));
    list.add(Card(
      child: Container(
        child: Column(
          children: [
            ListTile(
                title: Center(
              child: Text('类型'),
            )),
            SegmentBarView(
              items: RankingSettings.typeItems.map((e) => e.key).toList(),
              values: RankingSettings.typeItems.map((e) => e.value).toList(),
              onSelected: (String value) {
                setState(() {
                  RankingSettings.typeSelected = value;
                  if (RankingSettings.isR18) {
                    RankingSettings.modeR18Selected =
                        RankingSettings.modeR18Items.first.value;
                  } else {
                    RankingSettings.modeSelected =
                        RankingSettings.modeItems.first.value;
                  }
                });
              },
              selectedValue: RankingSettings.typeSelected,
            )
          ],
        ),
      ),
    ));
    list.add(SizedBox(height: 10));

    list.add(Card(
      child: Container(
        child: RankingSettings.isR18
            ? Column(
                children: [
                  ListTile(
                      title: Center(
                    child: Text('目标'),
                  )),
                  SegmentBarView(
                    items:
                        RankingSettings.modeR18Items.map((e) => e.key).toList(),
                    values: RankingSettings.modeR18Items
                        .map((e) => e.value)
                        .toList(),
                    onSelected: (String value) {
                      setState(() {
                        RankingSettings.modeR18Selected = value;
                      });
                    },
                    selectedValue: RankingSettings.modeR18Selected,
                  )
                ],
              )
            : Column(
                children: [
                  ListTile(
                      title: Center(
                    child: Text('目标'),
                  )),
                  SegmentBarView(
                    items: RankingSettings.modeItems.map((e) => e.key).toList(),
                    values:
                        RankingSettings.modeItems.map((e) => e.value).toList(),
                    onSelected: (String value) {
                      setState(() {
                        RankingSettings.modeSelected = value;
                      });
                    },
                    selectedValue: RankingSettings.modeSelected,
                  )
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
