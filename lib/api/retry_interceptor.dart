/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:retry_interceptor.dart
 * 创建时间:2021/8/25 下午4:15
 * 作者:小草
 */

import 'package:dio/dio.dart';
import 'package:pixiv_func_android/log/log.dart';

class RetryInterceptor extends InterceptorsWrapper {
  final Dio _httpClient;

  RetryInterceptor(Dio httpClient) : _httpClient = httpClient;

  int _retryCount = 0;

  static const _maxRetryCount = 2;

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    //(在收到完整标头之前连接已关闭) (握手期间连接终止) (超时)
    if (!err.message.contains('Connection closed before full header was received') &&
        !err.message.contains('Connection terminated during handshake') &&
        !err.message.contains('timed out')) {
      return handler.next(err);
    }
    //超过最大重试次数
    if (++_retryCount > _maxRetryCount) {
      _retryCount = 0;
      return handler.reject(err);
    }

    final options = err.requestOptions;

    Log.i('[${options.uri.host}:${options.uri.path}] 重试:$_retryCount次');

    //不能用try catch 因为Dio的严重BUG 偶尔会不抛异常(自作主张自己给处理了???)
    //可能是因为这个 (https://github.com/flutterchina/dio/issues/377)
    //好恶心的换行
    await _httpClient
        .request(
          options.path,
          options: Options(method: options.method, headers: options.headers, contentType: options.contentType),
          data: options.data,
          queryParameters: options.queryParameters,
        )
        .then((response) => handler.resolve(response))
        .catchError((e) => handler.reject(err))
        .whenComplete(() => _retryCount = 0);
  }
}
