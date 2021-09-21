/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:oauth_api.dart
 * 创建时间:2021/8/21 下午3:42
 * 作者:小草
 */

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'model/user_account.dart';
import 'retry_interceptor.dart';

class OAuthAPI {
  static const _TARGET_IP = '210.140.131.199';
  static const _TARGET_HOST = 'oauth.secure.pixiv.net';

  late final Dio _httpClient;

  static const FIELD_NAME = 'Authorization';

  static const _HASH_SALT = '28c1fdd170a5204386cb1313c7077b34f83e4aaf4aa829ce78c231e05b0bae2c';

  ///client_id 固定不变的
  static const _CLIENT_ID = 'MOBrBDS8blbauoSck0ZfDbtuzpyT';

  ///client_secret 固定不变的
  static const _CLIENT_SECRET = 'lsACyCD94FhDUtGTXi3QzcFE2uU1hqtDaKeqrdwj';

  String getIsoDate() {
    DateTime dateTime = new DateTime.now();
    DateFormat dateFormat = new DateFormat("yyyy-MM-dd'T'HH:mm:ss'+00:00'");
    return dateFormat.format(dateTime);
  }

  static String getHash(String string) {
    var content = new Utf8Encoder().convert(string);
    var digest = md5.convert(content);
    return digest.toString();
  }

  OAuthAPI() {
    final time = getIsoDate();
    _httpClient = Dio(
      BaseOptions(
        baseUrl: 'https://$_TARGET_IP',
        responseType: ResponseType.plain,
        contentType: Headers.formUrlEncodedContentType,
        headers: {
          'X-Client-Time': time,
          'X-Client-Hash': getHash(time + _HASH_SALT),
          'User-Agent': 'PixivAndroidApp/6.21.0 (Android 7.1.2; XiaoCao)',
          'App-OS': 'android',
          'App-OS-Version': '7.0.0',
          'App-Version': '6.1.9',
          'Accept-Language': 'zh-CN',
          'Host': _TARGET_HOST,
        },
        connectTimeout: 6 * 1000,
        receiveTimeout: 6 * 1000,
        sendTimeout: 6 * 1000,
      ),
    );
    _httpClient.interceptors.add(RetryInterceptor(_httpClient));
    // _httpClient.interceptors.add(LogInterceptor(responseBody: true));

    (_httpClient.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) {
        return true;
      };
    };
  }

  ///刷新token
  Future<UserAccount> refreshAuthToken(String refreshToken) async {
    final response = await _httpClient.post<String>('/auth/token', data: {
      'client_id': _CLIENT_ID,
      'client_secret': _CLIENT_SECRET,
      'include_policy': true,
      'grant_type': 'refresh_token',
      'refresh_token': refreshToken,
    });
    final data = UserAccount.fromJson(jsonDecode(response.data!));
    return data;
  }

  ///初始化token
  Future<UserAccount> initAccountAuthToken(String code, String codeVerifier) async {
    final response = await _httpClient.post<String>(
      '/auth/token',
      data: {
        "client_id": _CLIENT_ID,
        "client_secret": _CLIENT_SECRET,
        "include_policy": true,
        "grant_type": "authorization_code",
        "code_verifier": codeVerifier,
        'code': code,
        'redirect_uri': 'https://app-api.pixiv.net/web/v1/users/auth/pixiv/callback',
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    final data = UserAccount.fromJson(jsonDecode(response.data!));
    return data;
  }

  static const String _randomKeySet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';

  String randomString(int length) {
    return List.generate(length, (i) => _randomKeySet[Random.secure().nextInt(_randomKeySet.length)]).join();
  }

  String generateCodeChallenge(String s) {
    final codeChallenge = base64Url.encode(sha256.convert(ascii.encode(s)).bytes).replaceAll('=', '');
    return codeChallenge;
  }
}
