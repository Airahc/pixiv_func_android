/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:log.dart
 * 创建时间:2021/8/26 下午2:48
 * 作者:小草
 */
import 'package:logger/logger.dart';

class Log {
  static final Logger _logger = Logger(
    printer: PrefixPrinter(
      PrettyPrinter(
        stackTraceBeginIndex: 5,
        methodCount: 1,
      ),
    ),
  );

  static void v(dynamic message, [dynamic error, StackTrace? trace]) {
    _logger.v(message, error, trace);
  }

  static void d(dynamic message, [dynamic error, StackTrace? trace]) {
    _logger.d(message, error, trace);
  }

  static void i(dynamic message, [dynamic error, StackTrace? trace]) {
    _logger.i(message, error, trace);
  }

  static void w(dynamic message, [dynamic error, StackTrace? trace]) {
    _logger.w(message, error, trace);
  }

  static void e(dynamic message, [dynamic error, StackTrace? trace]) {
    _logger.e(message, error, trace);
  }

  static void wtf(dynamic message, [dynamic error, StackTrace? trace]) {
    _logger.wtf(message, error, trace);
  }
}
