/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:browsing_history_manager.dart
 * 创建时间:2021/10/2 下午11:12
 * 作者:小草
 */

import 'dart:convert';

import 'package:path/path.dart';
import 'package:pixiv_func_android/api/entity/illust.dart';
import 'package:pixiv_func_android/api/entity/image_urls.dart';
import 'package:pixiv_func_android/api/entity/meta_page.dart';
import 'package:pixiv_func_android/api/entity/meta_single_page.dart';
import 'package:pixiv_func_android/api/entity/tag.dart';
import 'package:pixiv_func_android/api/entity/user.dart';
import 'package:sqflite/sqflite.dart';

class BrowsingHistoryManager {
  late final Database _database;
  static const _databaseName = 'local_browsing_history_database.db';
  static const _tableName = 'local_browsing_history';

  Future<void> init() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), _databaseName),
      onCreate: (Database db, int version) {
        return db.execute(
          '''
          CREATE TABLE $_tableName
          (
            id INTEGER NOT NULL
              CONSTRAINT ${_tableName}_pk
                PRIMARY KEY AUTOINCREMENT,
            illust_id INTEGER NOT NULL,
            title TEXT NOT NULL,
            type TEXT NOT NULL,
            image_urls_json TEXT NOT NULL,
            caption TEXT NOT NULL,
            restrict INTEGER NOT NULL,
            user_json TEXT NOT NULL,
            tags_json TEXT NOT NULL,
            tools_json TEXT NOT NULL,
            create_date TEXT NOT NULL,
            page_count INTEGER NOT NULL,
            width INTEGER NOT NULL,
            height INTEGER NOT NULL,
            sanity_level INTEGER NOT NULL,
            x_restrict INTEGER NOT NULL,
            meta_single_page_json TEXT NOT NULL,
            meta_pages_json TEXT NOT NULL,
            total_view INTEGER NOT NULL,
            total_bookmarks INTEGER NOT NULL,
            is_bookmarked INTEGER(1) NOT NULL,
            visible INTEGER(1) NOT NULL,
            is_muted INTEGER(1) NOT NULL
          );
          CREATE UNIQUE INDEX ${_tableName}_illust_id_uindex ON $_tableName (illust_id);
          ''',
        );
      },
      version: 3,
    );
  }

  Future<int> insert(Illust illust) {
    return _database.insert(_tableName, _illustToMap(illust), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Illust>> query(int offset, int limit) async {
    final result = await _database.query(
      _tableName,
      offset: offset,
      limit: limit,
      orderBy: 'id desc',
    );

    return result.map((e) {
      return _mapToIllust(e);
    }).toList();
  }

  Future<int> delete(int illustId) {
    return _database.delete(_tableName, where: 'illust_id = ?', whereArgs: [illustId]);
  }

  Future<bool> exist(int illustId) async {
    final result = await _database.rawQuery('SELECT 1 FROM local_browsing_history WHERE illust_id = ?', [illustId]);
    return result.isNotEmpty;
  }

  Future<int> count() async {
    final result = await _database.rawQuery('SELECT COUNT(id) FROM local_browsing_history');
    return Sqflite.firstIntValue(result) as int;
  }

  Future<void> clear() async {
    await _database.execute('DELETE FROM $_tableName');
    await _database.execute('DELETE FROM sqlite_sequence WHERE name = ?', [_tableName]);
  }

  Map<String, dynamic> _illustToMap(Illust instance) {
    return {
      'illust_id': instance.id,
      'title': instance.title,
      'type': instance.type,
      'image_urls_json': jsonEncode(instance.imageUrls.toJson()),
      'caption': instance.caption,
      'restrict': instance.restrict,
      'user_json': jsonEncode(instance.user.toJson()),
      'tags_json': jsonEncode(instance.tags.map((e) => e.toJson()).toList()),
      'tools_json': jsonEncode(instance.tools),
      'create_date': instance.createDate,
      'page_count': instance.pageCount,
      'width': instance.width,
      'height': instance.height,
      'sanity_level': instance.sanityLevel,
      'x_restrict': instance.xRestrict,
      'meta_single_page_json': jsonEncode(instance.metaSinglePage.toJson()),
      'meta_pages_json': jsonEncode(instance.metaPages.map((e) => e.toJson()).toList()),
      'total_view': instance.totalView,
      'total_bookmarks': instance.totalBookmarks,
      'is_bookmarked': instance.isBookmarked ? 1 : 0,
      'visible': instance.visible ? 1 : 0,
      'is_muted': instance.isMuted ? 1 : 0,
    };
  }

  Illust _mapToIllust(Map<String, dynamic> map) {
    return Illust(
      map['illust_id'] as int,
      map['title'] as String,
      map['type'] as String,
      ImageUrls.fromJson(jsonDecode(map['image_urls_json']) as Map<String, dynamic>),
      map['caption'] as String,
      map['restrict'] as int,
      User.fromJson(jsonDecode(map['user_json']) as Map<String, dynamic>),
      (jsonDecode(map['tags_json']) as List<dynamic>).map((e) => Tag.fromJson(e as Map<String, dynamic>)).toList(),
      (jsonDecode(map['tools_json']) as List<dynamic>).map((e) => e as String).toList(),
      map['create_date'] as String,
      map['page_count'] as int,
      map['width'] as int,
      map['height'] as int,
      map['sanity_level'] as int,
      map['x_restrict'] as int,
      MetaSinglePage.fromJson(jsonDecode(map['meta_single_page_json']) as Map<String, dynamic>),
      (jsonDecode(map['meta_pages_json']) as List<dynamic>)
          .map((e) => MetaPage.fromJson(e as Map<String, dynamic>))
          .toList(),
      map['total_view'] as int,
      map['total_bookmarks'] as int,
      map['is_bookmarked'] as int == 1,
      map['visible'] as int == 1,
      map['is_muted'] as int == 1,
      null,
    );
  }
}
