import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:pixiv_xiaocao_android/api/entity/illust_many/illust_many.dart';
import 'package:pixiv_xiaocao_android/api/entity/search_autocomplete/search_autocomplete.dart';
import 'package:pixiv_xiaocao_android/config/config_util.dart';

import 'entity/bookmark_add/bookmark_add.dart';
import 'entity/bookmark_delete/bookmark_delete.dart';
import 'entity/bookmarks/bookmarks.dart';
import 'entity/follow_illusts/follow_illusts.dart';
import 'entity/following/following.dart';
import 'entity/illust_comment/illust_comment.dart';
import 'entity/illust_info/illust_info.dart';
import 'entity/illust_related/illust_related.dart';
import 'entity/profile_all/profile_all.dart';
import 'entity/ranking/ranking.dart';
import 'entity/recommender/recommender.dart';
import 'entity/search/search.dart';
import 'entity/search_suggestion/search_suggestion.dart';
import 'entity/user_bookmarks/user_bookmarks.dart';
import 'entity/user_info/user_info.dart';

class PixivRequest {
  static final _instance = PixivRequest();

  static PixivRequest get instance {
    return _instance;
  }

  late final Dio _httpClient;

  void updateHeaders() async {
    _httpClient.options.headers = {
      'Referer': ConfigUtil.referer,
      'User-Agent': ConfigUtil.userAgent,
      'Host': 'www.pixiv.net',
      'Cookie': ConfigUtil.instance.config.currentAccount.cookie,
      'x-user-id': ConfigUtil.instance.config.currentAccount.userId,
      'x-csrf-token': ConfigUtil.instance.config.currentAccount.token,
    };
  }

  PixivRequest() {
    _httpClient = Dio(BaseOptions(
        connectTimeout: 1000 * 5,
        receiveTimeout: 1000 * 5,
        sendTimeout: 1000 * 5))
      ..options.validateStatus = (int? status) {
        return true;
      }
      // ..interceptors.add(LogInterceptor(responseBody: true, requestBody: true))
      ..options.baseUrl = 'https://210.140.131.199';
    updateHeaders();

    (_httpClient.httpClientAdapter as DefaultHttpClientAdapter)
        .onHttpClientCreate = (client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        return true;
      };
      return client;
    };
  }

  Future<Following?> getFollowing(int userId, int offset, int limit,
      {void Function(Exception e, String response)? decodeException,
      void Function(Exception e)? requestException}) async {
    Following? followingData;

    try {
      final response = await _httpClient
          .get<String>('/ajax/user/$userId/following', queryParameters: {
        'offset': offset,
        'limit': limit,
        'rest': 'show',
        'tag': '',
        'lang': 'zh'
      });
      if (response.data != null) {
        try {
          followingData = Following.fromJson(jsonDecode(response.data!));
        } on Exception catch (e) {
          decodeException?.call(e, response.data!);
        }
      }
    } on Exception catch (e) {
      requestException?.call(e);
    }

    return followingData;
  }

  /// 获取排行榜
  Future<Ranking?> getRanking(
    int page, {
    required String mode,
    required String type,
    void Function(Exception e, String response)? decodeException,
    void Function(Exception e)? requestException,
  }) async {
    Ranking? rankingData;
    try {
      var response = await _httpClient
          .get<String>('/touch/ajax/ranking/illust?', queryParameters: {
        'mode': mode,
        'page': page,
        'type': type,
        'lang': 'zh'
      });
      if (response.data != null) {
        try {
          rankingData = Ranking.fromJson(jsonDecode(response.data!));
        } on Exception catch (e) {
          decodeException?.call(e, response.data!);
        }
      }
    } on Exception catch (e) {
      requestException?.call(e);
    }

    return rankingData;
  }

  /// 查询用户信息
  Future<UserInfo?> queryUserInfo(int userId,
      {void Function(Exception e, String response)? decodeException,
      void Function(Exception e)? requestException}) async {
    UserInfo? userInfoData;
    try {
      var response = await _httpClient.get<String>('/touch/ajax/user/details',
          queryParameters: {'id': userId, 'lang': 'zh'});
      if (response.data != null) {
        try {
          userInfoData = UserInfo.fromJson(jsonDecode(response.data!));
        } on Exception catch (e) {
          decodeException?.call(e, response.data!);
        }
      }
    } on Exception catch (e) {
      requestException?.call(e);
    }

    return userInfoData;
  }

  /// 查询插画信息
  Future<IllustInfo?> queryIllustInfo(int illustId,
      {void Function(Exception e, String response)? decodeException,
      void Function(Exception e)? requestException}) async {
    IllustInfo? illustInfoData;

    try {
      var response = await _httpClient.get<String>('/touch/ajax/illust/details',
          queryParameters: {'illust_id': illustId, 'lang': 'zh'});
      if (response.data != null) {
        try {
          illustInfoData = IllustInfo.fromJson(jsonDecode(response.data!));
        } on Exception catch (e) {
          decodeException?.call(e, response.data!);
        }
      }
    } on Exception catch (e) {
      requestException?.call(e);
    }

    return illustInfoData;
  }

  /// 获取插画评论区
  Future<IllustComment?> getIllustComments(
    int workId,
    int page, {
    void Function(Exception e)? requestException,
    void Function(Exception e, String response)? decodeException,
  }) async {
    IllustComment? illustCommentData;

    try {
      var response = await _httpClient.get<String>(
          '/touch/ajax/comment/illust?',
          queryParameters: {'work_id': workId, 'page': page, 'lang': 'zh'});

      if (response.data != null) {
        try {
          illustCommentData =
              IllustComment.fromJson(jsonDecode(response.data!));
        } on Exception catch (e) {
          decodeException?.call(e, response.data!);
        }
      }
    } on Exception catch (e) {
      requestException?.call(e);
    }

    return illustCommentData;
  }

  /// 获取评论回复
  Future<IllustComment?> getCommentReplies(
    int commentId,
    int page, {
    void Function(Exception e)? requestException,
    void Function(Exception e, String response)? decodeException,
  }) async {
    IllustComment? illustCommentData;

    try {
      var response = await _httpClient
          .get<String>('/touch/ajax/comment/illust/replies?', queryParameters: {
        'comment_id': commentId,
        'page': page,
        'lang': 'zh'
      });

      if (response.data != null) {
        try {
          illustCommentData =
              IllustComment.fromJson(jsonDecode(response.data!));
        } on Exception catch (e) {
          decodeException?.call(e, response.data!);
        }
      }
    } on Exception catch (e) {
      requestException?.call(e);
    }

    return illustCommentData;
  }

  ///获取插画的相关推荐(同类型)
  Future<IllustRelated?> getIllustRelated(
    int illustId,
    int limit, {
    void Function(Exception e, String response)? decodeException,
    void Function(Exception e)? requestException,
  }) async {
    IllustRelated? illustRelatedData;

    try {
      var response = await _httpClient.get<String>(
          '/touch/ajax/recommender/related/illust',
          queryParameters: {
            'illust_id': illustId,
            'limit': limit,
            'exclude_illusts': 0,
            'lang': 'zh',
          });

      if (response.data != null) {
        try {
          illustRelatedData =
              IllustRelated.fromJson(jsonDecode(response.data!));
        } on Exception catch (e) {
          decodeException?.call(e, response.data!);
        }
      }
    } on Exception catch (e) {
      requestException?.call(e);
    }

    return illustRelatedData;
  }

  /// 获取自己关注的用户的插画
  Future<FollowIllusts?> getFollowIllusts(
    int page, {
    required bool r18,
    void Function(Exception e, String response)? decodeException,
    void Function(Exception e)? requestException,
  }) async {
    FollowIllusts? followIllustsData;

    try {
      var response = await _httpClient
          .get<String>('/touch/ajax/follow/latest', queryParameters: {
        'type': 'illusts',
        'p': page,
        'include_meta': 0,
        'lang': 'zh',
        'mode': r18 ? 'r18' : 'safe'
      });
      if (response.data != null) {
        try {
          followIllustsData =
              FollowIllusts.fromJson(jsonDecode(response.data!));
        } on Exception catch (e) {
          decodeException?.call(e, response.data!);
        }
      }
    } on Exception catch (e) {
      requestException?.call(e);
    }

    return followIllustsData;
  }

  /// 获取用户所有作品的编号
  Future<ProfileAll?> getUserAllWork(int userId,
      {void Function(Exception e, String response)? decodeException,
      void Function(Exception e)? requestException}) async {
    ProfileAll? profileAllData;

    try {
      var response = await _httpClient
          .get<String>('/ajax/user/$userId/profile/all', queryParameters: {
        'lang': 'zh',
      });
      if (response.data != null) {
        try {
          profileAllData = ProfileAll.fromJson(jsonDecode(response.data!));
        } on Exception catch (e) {
          decodeException?.call(e, response.data!);
        }
      }
    } on Exception catch (e) {
      requestException?.call(e);
    }

    return profileAllData;
  }

  /// 查询作品信息
  Future<IllustMany?> queryIllustsById(List<int> ids,
      {void Function(Exception e, String response)? decodeException,
      void Function(Exception e)? requestException}) async {
    IllustMany? illustMany;

    try {
      var response = await _httpClient
          .get<String>('/touch/ajax/illust/details/many', queryParameters: {
        'illust_ids[]': ids,
        'lang': 'zh',
      });

      if (response.data != null) {
        try {
          var map = jsonDecode(response.data!);
          illustMany = IllustMany.fromJson(map);
        } on Exception catch (e) {
          decodeException?.call(e, response.data!);
        }
      }
    } on Exception catch (e) {
      requestException?.call(e);
    }

    return illustMany;
  }

  /// 查询用户收藏的图
  Future<UserBookmarks?> queryUserBookmarks(int userId, int offset, int limit,
      {void Function(Exception e, String response)? decodeException,
      void Function(Exception e)? requestException}) async {
    UserBookmarks? userBookmarksData;

    try {
      var response = await _httpClient.get<String>(
          '/ajax/user/$userId/illusts/bookmarks',
          queryParameters: {
            'tag': '',
            'offset': offset,
            'limit': limit,
            'rest': 'show',
            'lang': 'zh',
          });
      if (response.data != null) {
        try {
          userBookmarksData =
              UserBookmarks.fromJson(jsonDecode(response.data!));
        } on Exception catch (e) {
          decodeException?.call(e, response.data!);
        }
      }
    } on Exception catch (e) {
      requestException?.call(e);
    }

    return userBookmarksData;
  }

  /// 获取推荐
  Future<Recommender?> getRecommender(
      {bool? r18,
      void Function(Exception e, String response)? decodeException,
      void Function(Exception e)? requestException}) async {
    Recommender? recommenderData;

    try {
      var response = await _httpClient
          .get<String>('/touch/ajax/recommender/illust', queryParameters: {
        'mode': r18 == null
            ? 'all'
            : r18
                ? 'r18'
                : 'safe',
        'lang': 'zh',
      });

      if (response.data != null) {
        try {
          recommenderData = Recommender.fromJson(jsonDecode(response.data!));
        } on Exception catch (e) {
          decodeException?.call(e, response.data!);
        }
      }
    } on Exception catch (e) {
      requestException?.call(e);
    }
    return recommenderData;
  }

  /// 获取书签(List)
  Future<Bookmarks?> getBookmarks(int userId, int page,
      {void Function(Exception e, String response)? decodeException,
      void Function(Exception e)? requestException}) async {
    Bookmarks? bookmarksData;

    try {
      var response = await _httpClient.get<String>('/touch/ajax/user/bookmarks',
          queryParameters: {
            'id': userId,
            'type': 'illust',
            'p': page,
            'lang': 'zh'
          });

      if (response.data != null) {
        try {
          bookmarksData = Bookmarks.fromJson(jsonDecode(response.data!));
        } on Exception catch (e) {
          decodeException?.call(e, response.data!);
        }
      }
    } on Exception catch (e) {
      requestException?.call(e);
    }
    return bookmarksData;
  }

  void downloadImage(String url, String savePath,
      {void Function(int count, int total)? onReceiveProgress}) async {
    Dio httpClient = Dio(BaseOptions(
        connectTimeout: 1000 * 10,
        receiveTimeout: 1000 * 10,
        sendTimeout: 1000 * 10))
      ..options.headers = {
        'Referer': ConfigUtil.referer,
        'User-Agent': ConfigUtil.userAgent
      };

    await httpClient.download(url, savePath,
        onReceiveProgress: onReceiveProgress);
    httpClient.close();
  }

  ///添加书签
  Future<BookmarkAdd?> bookmarkAdd(int illustId,
      {required String comment,
      required List<String> tags,
      void Function(Exception e, String response)? decodeException,
      void Function(Exception e)? requestException}) async {
    BookmarkAdd? bookmarkAddData;

    try {
      var response = await _httpClient.post<String>(
        '/touch/ajax_api/ajax_api.php',
        data: FormData.fromMap(
          {
            'mode': 'add_bookmark_illust',
            'restrict': 0,
            'tag': tags,
            'id': illustId,
            'comment': comment,
          },
        ),
      );

      if (response.data != null) {
        try {
          var map = jsonDecode(response.data!);
          bookmarkAddData = BookmarkAdd.fromJson(map);
        } on Exception catch (e) {
          decodeException?.call(e, response.data!);
        }
      }
    } on Exception catch (e) {
      requestException?.call(e);
    }

    return bookmarkAddData;
  }

  ///删除书签
  Future<BookmarkDelete?> bookmarkDelete(int bookmarkId,
      {void Function(Exception e, String response)? decodeException,
      void Function(Exception e)? requestException}) async {
    BookmarkDelete? bookmarkDeleteData;

    try {
      var response = await _httpClient.post<String>(
        '/touch/ajax_api/ajax_api.php',
        data: FormData.fromMap(
          {
            'mode': 'delete_bookmark_illust',
            'id': bookmarkId,
          },
        ),
      );

      if (response.data != null) {
        try {
          var map = jsonDecode(response.data!);
          bookmarkDeleteData = BookmarkDelete.fromJson(map);
        } on Exception catch (e) {
          decodeException?.call(e, response.data!);
        }
      }
    } on Exception catch (e) {
      requestException?.call(e);
    }

    return bookmarkDeleteData;
  }

  Future<bool> followUserAdd(int userId,
      {void Function(Exception e)? requestException}) async {
    bool success = false;

    try {
      var response = await _httpClient.post<String>('/bookmark_add.php',
          data: FormData.fromMap({
            'mode': 'add',
            'type': 'user',
            'user_id': '$userId',
            'tag': '',
            'restrict': '0',
            'format': 'json'
          }));
      if (response.data != null) {
        success = response.data! == '[]';
      }
    } on Exception catch (e) {
      requestException?.call(e);
    }
    return success;
  }

  Future<bool> followUserDelete(int userId,
      {void Function(Exception e)? requestException}) async {
    bool success = false;

    try {
      var response = await _httpClient.post<String>('/rpc_group_setting.php',
          data: FormData.fromMap(
              {'mode': 'del', 'type': 'bookuser', 'id': '$userId'}));
      if (response.data != null) {
        var body = jsonDecode(response.data!);
        if (body['user_id'] is String) {
          success = int.parse(body['user_id'] as String) == userId;
        } else {
          success = false;
        }
      }
    } on Exception catch (e) {
      requestException?.call(e);
    }
    return success;
  }

  Future<SearchSuggestion?> getSearchSuggestion({
    String mode = 'all',
    void Function(Exception e)? requestException,
    void Function(Exception e, String response)? decodeException,
  }) async {
    SearchSuggestion? searchSuggestionData;

    try {
      var response = await _httpClient.get<String>('/ajax/search/suggestion',
          queryParameters: {'mode': mode, 'lang': 'zh'});

      if (response.data != null) {
        try {
          searchSuggestionData =
              SearchSuggestion.fromJson(jsonDecode(response.data!));
        } on Exception catch (e) {
          decodeException?.call(e, response.data!);
        }
      }
    } on Exception catch (e) {
      requestException?.call(e);
    }

    return searchSuggestionData;
  }

  Future<SearchAutocomplete?> getSearchAutocomplete(
    String keyword, {
    void Function(Exception e)? requestException,
    void Function(Exception e, String response)? decodeException,
  }) async {
    SearchAutocomplete? searchAutocompleteData;

    try {
      var response = await _httpClient.get<String>(
          '/touch/ajax/search/autocomplete',
          queryParameters: {'keyword': keyword, 'lang': 'zh'});

      if (response.data != null) {
        try {
          searchAutocompleteData =
              SearchAutocomplete.fromJson(jsonDecode(response.data!));
        } on Exception catch (e) {
          decodeException?.call(e, response.data!);
        }
      }
    } on Exception catch (e) {
      requestException?.call(e);
    }

    return searchAutocompleteData;
  }

  Future<Search?> search(
    String keyword, {
    required int page,
    required String mode,
    required String type,
    required String searchMode,
    String startDate = '',
    String endDate = '',
    void Function(Exception e)? requestException,
    void Function(Exception e)? decodeException,
  }) async {
    Search? searchData;

    try {
      var response = await _httpClient
          .get<String>('/touch/ajax/search/illusts', queryParameters: {
        'include_meta': '0',
        'mode': mode,
        'scd': startDate,
        'ecd': endDate,
        'type': type,
        's_mode': searchMode,
        'p': page,
        'word': keyword,
        'lang': 'zh'
      });

      if (response.data != null) {
        try {
          searchData = Search.fromJson(jsonDecode(response.data!));
        } on Exception catch (e) {
          decodeException?.call(e);
        }
      }
    } on Exception catch (e) {
      requestException?.call(e);
    }

    return searchData;
  }
}
