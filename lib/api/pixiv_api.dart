/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:pixiv_api.dart
 * 创建时间:2021/8/21 下午12:47
 * 作者:小草
 */

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:pixiv_func_android/api/model/bookmark_tags.dart';
import 'package:pixiv_func_android/api/model/novels.dart';
import 'auth_token_interceptor.dart';
import 'model/search_novel.dart';
import 'retry_interceptor.dart';
import 'model/comments.dart';
import 'model/error_message.dart';
import 'model/illust_detail.dart';
import 'model/illusts.dart';
import 'model/search_autocomplete.dart';
import 'model/trending_tags.dart';
import 'model/ugoira_metadata.dart';
import 'model/users.dart';
import 'model/search_illust.dart';
import 'model/user_detail.dart';
import 'entity/comment.dart';

class PixivAPI {
  static const _targetIP = '210.140.131.199';
  static const _targetHost = 'app-api.pixiv.net';
  final Dio httpClient = Dio(
    BaseOptions(
      baseUrl: 'https://$_targetIP',
      responseType: ResponseType.plain,
      headers: {
        'User-Agent': 'PixivAndroidApp/6.21.1 (Android 7.1.2; XiaoCao)',
        'App-OS': 'android',
        'App-OS-Version': '7.1.2',
        'App-Version': '6.21.1',
        'Accept-Language': 'zh',
        'Host': _targetHost
      },
      connectTimeout: 5 * 1000,
      receiveTimeout: 5 * 1000,
      sendTimeout: 5 * 1000,
    ),
  );

  PixivAPI() {
    httpClient.interceptors.addAll(
      [
        RetryInterceptor(httpClient),
        AuthTokenInterceptor(),
      ],
    );
  }

  ///```kotlin
  ///suspend inline fun <reified T> next(url: String): T {
  ///     return httpClient.get(url.replaceFirst("app-api.pixiv.net", "210.140.131.187"))
  ///}
  ///```
  Future<T> next<T>(String url) async {
    final response = await httpClient.get<String>(url.replaceFirst(_targetHost, _targetIP));

    final responseData = response.data!;

    if (T == Comments) {
      return Comments.fromJson(jsonDecode(responseData)) as T;
    }
    if (T == Illusts) {
      return Illusts.fromJson(jsonDecode(responseData)) as T;
    }
    if (T == Novels) {
      return Novels.fromJson(jsonDecode(responseData)) as T;
    }
    if (T == Users) {
      return Users.fromJson(jsonDecode(responseData)) as T;
    }
    if (T == SearchIllust) {
      return SearchIllust.fromJson(jsonDecode(responseData)) as T;
    }
    if (T == BookmarkTags) {
      return BookmarkTags.fromJson(jsonDecode(responseData)) as T;
    }
    throw Exception('类型错误');
  }

  ///获取用户详细信息 <br/>
  ///如果没有查询到会返回404 : [ErrorMessage.fromJson] => <br/>
  ///{ user_message:"该作品已被删除，或作品ID不存在。", message:"", reason:"", user_message_details:{} } <br/>
  ///[userId] - 用户ID
  Future<UserDetail> getUserDetail(int userId) async {
    final response = await httpClient.get<String>(
      '/v1/user/detail',
      queryParameters: {
        'filter': 'for_android',
        'user_id': userId,
      },
    );
    final data = UserDetail.fromJson(jsonDecode(response.data!));
    return data;
  }

  ///获取用户收藏的插画 <br/>
  ///[userId] - 用户ID <br/>
  ///[restrict] - 为ture获取公开的(public) 反之不公开(private)
  Future<Illusts> getUserIllustBookmarks(int userId, {bool restrict = true}) async {
    final response = await httpClient.get<String>(
      '/v1/user/bookmarks/illust',
      queryParameters: {
        'user_id': userId,
        'restrict': restrict ? 'public' : 'private',
      },
    );
    final data = Illusts.fromJson(jsonDecode(response.data!));
    return data;
  }

  ///获取用户收藏的小说 <br/>
  ///[userId] - 用户ID <br/>
  ///[restrict] - 为ture获取公开的(public) 反之不公开(private)
  Future<Novels> getUserNovelBookmarks(int userId, {bool restrict = true}) async {
    final response = await httpClient.get<String>(
      '/v1/user/bookmarks/novel',
      queryParameters: {
        'user_id': userId,
        'restrict': restrict ? 'public' : 'private',
      },
    );
    final data = Novels.fromJson(jsonDecode(response.data!));
    return data;
  }

  ///获取用户的插画 <br/>
  ///[userId] - 用户ID <br/>
  ///[type] - 类型([WorkType])
  Future<Illusts> getUserIllusts(int userId, String type) async {
    final response = await httpClient.get<String>(
      '/v1/user/illusts',
      queryParameters: {
        'filter': 'for_android',
        'user_id': userId,
        'type': type,
      },
    );
    final data = Illusts.fromJson(jsonDecode(response.data!));
    return data;
  }

  ///获取用户的小说 <br/>
  ///[userId] - 用户ID <br/>
  Future<Novels> getUserNovels(int userId) async {
    final response = await httpClient.get<String>(
      '/v1/user/novels',
      queryParameters: {'user_id': userId},
    );
    final data = Novels.fromJson(jsonDecode(response.data!));
    return data;
  }

  ///获取推荐作品 <br/>
  ///[type] - 类型([WorkType])
  Future<Illusts> getRecommendedIllusts(String type) async {
    final response = await httpClient.get<String>(
      '/v1/$type/recommended',
      queryParameters: {
        'filter': 'for_android',
      },
    );
    final data = Illusts.fromJson(jsonDecode(response.data!));
    return data;
  }

  ///获取推荐小说
  Future<Novels> getRecommendedNovels() async {
    final response = await httpClient.get<String>(
      '/v1/novel/recommended',
      queryParameters: {
        'include_ranking_novels': false,
        'include_privacy_policy': false,
      },
    );
    final data = Novels.fromJson(jsonDecode(response.data!));
    return data;
  }

  ///获取推荐作品 <br/>
  ///[mode] - 方式([RankingMode])
  Future<Illusts> getRanking(String mode) async {
    final response = await httpClient.get<String>(
      '/v1/illust/ranking',
      queryParameters: {
        'filter': 'for_android',
        'mode': mode,
      },
    );
    final data = Illusts.fromJson(jsonDecode(response.data!));
    return data;
  }

  ///获取推荐标签(搜索用的)
  Future<TrendingTags> getTrendingTags() async {
    final response = await httpClient.get<String>(
      '/v1/trending-tags/illust',
      queryParameters: {
        'filter': 'for_android',
      },
    );
    final data = TrendingTags.fromJson(jsonDecode(response.data!));
    return data;
  }

  ///获取推荐用户
  Future<Users> getRecommendedUsers() async {
    final response = await httpClient.get<String>(
      '/v1/user/recommended',
      queryParameters: {
        'filter': 'for_android',
      },
    );
    final data = Users.fromJson(jsonDecode(response.data!));
    return data;
  }

  ///获取关注用户 <br/>
  ///[userId] - 用户ID <br/>
  ///[restrict] - 为ture获取公开的(public) 反之不公开(private)
  Future<Users> getFollowingUsers(int userId, {bool restrict = true}) async {
    final response = await httpClient.get<String>(
      '/v1/user/following',
      queryParameters: {
        'filter': 'for_android',
        'user_id': userId,
        'restrict': restrict ? 'public' : 'private',
      },
    );
    final data = Users.fromJson(jsonDecode(response.data!));
    return data;
  }

  ///获取关注者的新插画 <br/>
  ///[restrict] - 为ture获取公开的(public) 反之不公开(private) null(全部)
  Future<Illusts> getFollowerNewIllusts({required bool? restrict}) async {
    final response = await httpClient.get<String>(
      '/v2/illust/follow',
      queryParameters: {
        'filter': 'for_android',
        'restrict': null == restrict
            ? 'all'
            : restrict
                ? 'public'
                : 'private',
      },
    );
    final data = Illusts.fromJson(jsonDecode(response.data!));
    return data;
  }

  ///获取关注者的新小说 <br/>
  ///[restrict] - 为ture获取公开的(public) 反之不公开(private) null(全部)
  Future<Novels> getFollowerNewNovels({required bool? restrict}) async {
    final response = await httpClient.get<String>(
      '/v1/novel/follow',
      queryParameters: {
        'filter': 'for_android',
        'restrict': null == restrict
            ? 'all'
            : restrict
                ? 'public'
                : 'private',
      },
    );
    final data = Novels.fromJson(jsonDecode(response.data!));
    return data;
  }

  ///获取最近发布的插画 <br/>
  ///[type] - 类型([WorkType]) illust , manga
  Future<Illusts> getNewIllusts(String type) async {
    final response = await httpClient.get<String>(
      '/v1/illust/new',
      queryParameters: {
        'filter': 'for_android',
        'content_type': type,
      },
    );
    final data = Illusts.fromJson(jsonDecode(response.data!));
    return data;
  }

  ///获取最近发布的插画 <br/>
  ///[type] - 类型([WorkType]) illust , manga
  Future<Novels> getNewNovels() async {
    final response = await httpClient.get<String>(
      '/v1/novel/new',
    );
    final data = Novels.fromJson(jsonDecode(response.data!));
    return data;
  }

  ///获取插画的相关推荐 <br/>
  ///[illustId] - 插画ID
  Future<Illusts> getIllustRelated(int illustId) async {
    final response = await httpClient.get<String>(
      '/v2/illust/related',
      queryParameters: {
        'filter': 'for_android',
        'illust_id': illustId,
      },
    );
    final data = Illusts.fromJson(jsonDecode(response.data!));
    return data;
  }

  ///获取插画详细 <br/>
  ///如果没有查询到会返回404 : [ErrorMessage.fromJson] => <br/>
  ///{ user_message:"该作品已被删除，或作品ID不存在。", message:"", reason:"", user_message_details:{} } <br/>
  ///[illustId] - 插画ID <br/>
  Future<IllustDetail> getIllustDetail(int illustId) async {
    final response = await httpClient.get<String>(
      '/v1/illust/detail',
      queryParameters: {
        'filter': 'for_android',
        'illust_id': illustId,
        'include_ranking_illusts': false,
        'include_privacy_policy': false,
      },
    );

    final data = IllustDetail.fromJson(jsonDecode(response.data!));
    return data;
  }

  ///获取小说HTML页面 <br/>
  ///[illustId] - 插画ID
  Future<String> getNovelHtml(int illustId) async {
    final response = await httpClient.get<String>(
      '/webview/v1/novel',
      queryParameters: {
        'id': illustId,
      },
    );
    return response.data!;
  }

  ///获取动图
  ///[illustId] 插画ID
  Future<UgoiraMetadata> getUgoiraMetadata(int illustId) async {
    final response = await httpClient.get<String>(
      '/v1/ugoira/metadata',
      queryParameters: {
        'illust_id': illustId,
      },
    );

    final data = UgoiraMetadata.fromJson(jsonDecode(response.data!));
    return data;
  }

  ///获取评论的回复 <br/>
  ///[commentId] - 评论ID
  Future<Comments> getCommentReplies(int commentId) async {
    final response = await httpClient.get<String>(
      '/v2/illust/comment/replies',
      queryParameters: {
        'comment_id': commentId,
      },
    );
    final data = Comments.fromJson(jsonDecode(response.data!));
    return data;
  }

  ///获取插画的评论 <br/>
  ///[illustId] - 插画ID
  Future<Comments> getIllustComments(int illustId) async {
    final response = await httpClient.get<String>(
      '/v3/illust/comments',
      queryParameters: {
        'illust_id': illustId,
      },
    );
    final data = Comments.fromJson(jsonDecode(response.data!));
    return data;
  }

  ///添加评论(评论一个插画) <br/>
  ///[illustId] - 插画ID <br/>
  ///[comment] - 评论内容 <br/>
  ///[stampId] - 表情包ID <br/>
  ///[parentCommentId] - 父评论ID(用来回复)
  Future<Comment> addComment(
    int illustId, {
    String comment = '',
    int? stampId,
    int? parentCommentId,
  }) async {
    final response = await httpClient.post<String>(
      '/v1/illust/comment/add',
      data: FormData.fromMap(
        {
          'illust_id': illustId,
          'comment': comment,
          'stamp_id': stampId,
          'parent_comment_id': parentCommentId,
        }..removeWhere((key, value) => null == value),
      ),
    );
    final data = Comment.fromJson(jsonDecode(response.data!)['comment']);
    return data;
  }

  ///删除评论(自己的) <br/>
  ///[commentId] - 评论ID
  Future<void> deleteComment(int commentId) async {
    await httpClient.post<String>(
      '/v1/illust/comment/delete',
      data: FormData.fromMap(
        {
          'comment_id': commentId,
        },
      ),
    );
  }

  ///**搜索**的**关键字**自动补全 <br/>
  ///[word] - 关键字
  Future<SearchAutocomplete> searchAutocomplete(String word) async {
    final response = await httpClient.get<String>(
      '/v2/search/autocomplete',
      queryParameters: {
        'merge_plain_keyword_results': true,
        'word': word,
      },
    );
    final data = SearchAutocomplete.fromJson(jsonDecode(response.data!));
    return data;
  }

  ///搜索 <br/>
  ///[word] - 关键字 <br/>
  ///[sort] - 排序([SearchSort]) <br/>
  ///[target] - 搜索目标([SearchTarget]) <br/>
  ///[startDate] - 开始时间(必须跟[endDate]一起填) <br/>
  ///[endDate] - 结束时间(必须跟[startDate]一起填) <br/>
  ///[bookmarkTotal] - 收藏数量 100, 250, 500, 1000, 5000, 7500 , 10000, 20000, 30000, 50000
  Future<SearchIllust> searchIllust(
    String word,
    String sort,
    String target, {
    String? startDate,
    String? endDate,
    int? bookmarkTotal,
  }) async {
    final response = await httpClient.get<String>(
      '/v1/search/illust',
      queryParameters: {
        'filter': 'for_android',
        'include_translated_tag_results': true,
        'merge_plain_keyword_results': true,
        'word': null != bookmarkTotal ? '$word ${bookmarkTotal}users入り' : word,
        'sort': sort,
        'search_target': target,
        'start_date': startDate,
        'end_date': endDate,
      }..removeWhere((key, value) => null == value),
    );
    final data = SearchIllust.fromJson(jsonDecode(response.data!));
    return data;
  }

  ///搜索 <br/>
  ///[word] - 关键字 <br/>
  ///[sort] - 排序([SearchSort]) <br/>
  ///[target] - 搜索目标([SearchTarget]) <br/>
  ///[startDate] - 开始时间(必须跟[endDate]一起填) <br/>
  ///[endDate] - 结束时间(必须跟[startDate]一起填) <br/>
  ///[bookmarkTotal] - 收藏数量 100, 250, 500, 1000, 5000, 7500, 10000, 20000, 30000, 50000
  Future<SearchNovel> searchNovel(
    String word,
    String sort,
    String target, {
    String? startDate,
    String? endDate,
    int? bookmarkTotal,
  }) async {
    final response = await httpClient.get<String>(
      '/v1/search/novel',
      queryParameters: {
        'include_translated_tag_results': true,
        'merge_plain_keyword_results': true,
        'word': null != bookmarkTotal ? '$word ${bookmarkTotal}users入り' : word,
        'sort': sort,
        'search_target': target,
        'start_date': startDate,
        'end_date': endDate,
      }..removeWhere((key, value) => null == value),
    );
    final data = SearchNovel.fromJson(jsonDecode(response.data!));
    return data;
  }

  ///搜索用户
  Future<Users> searchUsers(String word) async {
    final response = await httpClient.get<String>(
      '/v1/search/user',
      queryParameters: {
        'filter': 'for_android',
        'word': word,
      },
    );
    final data = Users.fromJson(jsonDecode(response.data!));
    return data;
  }

  Future<BookmarkTags> getBookmarkTags(int userId, {bool restrict = true, bool isNovel = false}) async {
    final response = await httpClient.get<String>(
      '/v1/user/bookmark-tags/${isNovel ? 'novel' : 'illust'}',
      queryParameters: {
        'user_id': userId,
        'restrict': restrict ? 'public' : 'private',
      },
    );
    final data = BookmarkTags.fromJson(jsonDecode(response.data!));
    return data;
  }

  ///收藏插画 <br/>
  ///[illustId] - 插画ID <br/>
  ///[tags] - 标签(自己添加的) <br/>
  ///[restrict] 为ture获取公开的(public) 反之不公开(private) <br/>
  ///[isNovel] 小说
  Future<void> bookmarkAdd(int illustId,
      {List<String> tags = const [], bool restrict = true, bool isNovel = false}) async {
    await httpClient.post<String>(
      '/v2/${isNovel ? 'novel' : 'illust'}/bookmark/add',
      data: FormData.fromMap(
        {
          '${isNovel ? 'novel' : 'illust'}_id': illustId,
          'restrict': restrict ? 'public' : 'private',
          'tags': tags,
        },
      ),
    );
  }

  ///取消收藏插画 <br/>
  ///[illustId] - 插画ID <br/>
  ///[isNovel] 小说
  Future<void> bookmarkDelete(int illustId, {bool isNovel = false}) async {
    await httpClient.post<String>(
      '/v1/${isNovel ? 'novel' : 'illust'}/bookmark/delete',
      data: FormData.fromMap(
        {
          '${isNovel ? 'novel' : 'illust'}_id': illustId,
        },
      ),
    );
  }

  ///收藏插画 <br/>
  ///[userId] - 用户ID <br/>
  ///[restrict] 为ture获取公开的(public) 反之不公开(private)
  Future<void> followAdd(int userId, {bool restrict = true}) async {
    await httpClient.post<String>(
      '/v1/user/follow/add',
      data: FormData.fromMap(
        {
          'user_id': userId,
          'restrict': restrict ? 'public' : 'private',
        },
      ),
    );
  }

  ///取消收藏插画 <br/>
  ///[userId] - 用户ID
  Future<void> followDelete(int userId) async {
    await httpClient.post<String>(
      '/v1/user/follow/delete',
      data: FormData.fromMap(
        {
          'user_id': userId,
        },
      ),
    );
  }
}
