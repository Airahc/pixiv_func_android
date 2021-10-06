/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:html_rich_text.dart
 * 创建时间:2021/8/29 上午8:51
 * 作者:小草
 */

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as html show parseFragment;
import 'package:html/dom.dart' as html;
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/log/log.dart';
import 'package:pixiv_func_android/ui/page/illust/illust_page.dart';
import 'package:pixiv_func_android/ui/page/user/user_page.dart';
import 'package:pixiv_func_android/util/page_utils.dart';
import 'package:pixiv_func_android/util/utils.dart';

//必须是StatefulWidget才能响应点击事件
class HtmlRichText extends StatefulWidget {
  final String htmlString;
  final bool showOriginal;

  const HtmlRichText(this.htmlString, {Key? key, this.showOriginal = false}) : super(key: key);

  @override
  _HtmlRichTextState createState() => _HtmlRichTextState();
}

class _HtmlRichTextState extends State<HtmlRichText> {
  static const _aTagStyle = TextStyle(color: Colors.blue);
  static const _aTagStrongStyle = TextStyle(color: Colors.blue, fontSize: 22);
  static const _strongTagStyle = TextStyle(fontSize: 22);
  static const _knownStrongLinkStyle = TextStyle(fontSize: 22, color: Colors.pinkAccent);
  static const _knownLinkStyle = TextStyle(color: Colors.pinkAccent);

  TextSpan _buildNode(html.Node node, {bool isStrong = false}) {
    if (node.nodeType == html.Node.TEXT_NODE) {
      return TextSpan(text: node.text);
    } else if (node.nodeType == html.Node.ELEMENT_NODE) {
      switch (node.toString()) {
        case '<html br>':
          return const TextSpan(text: '\n');
        case '<html a>':
          final href = node.attributes['href']!;
          final text = node.text!;

          if (Utils.urlIsTwitter(href)) {
            final twitterUsername = Utils.findTwitterUsernameByUrl(href);
            return TextSpan(
              text: 'Twitter:$twitterUsername',
              style: isStrong ? _knownStrongLinkStyle : _knownLinkStyle,
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  if (!await platformAPI.urlLaunch('twitter://user?screen_name=$twitterUsername')) {
                    Log.d('没有Twitter APK');
                    await platformAPI.urlLaunch(href);
                  }
                },
            );
          }
          if (Utils.urlIsIllust(href)) {
            final illustId = Utils.findIllustIdByUrl(href);
            return TextSpan(
              text: '插画ID:$illustId',
              style: isStrong ? _knownStrongLinkStyle : _knownLinkStyle,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  PageUtils.to(context, IllustPage(illustId));
                },
            );
          }
          if (Utils.urlIsUser(href)) {
            final userId = Utils.findUserIdByUrl(href);
            return TextSpan(
              text: '用户ID:$userId',
              style: isStrong ? _knownStrongLinkStyle : _knownLinkStyle,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  PageUtils.to(context, UserPage(userId));
                },
            );
          }

          return TextSpan(
            text: text,
            style: isStrong ? _aTagStrongStyle : _aTagStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                await platformAPI.urlLaunch(href);
              },
          );

        case '<html strong>':
          if (node.hasChildNodes()) {
            return _buildNode(node.firstChild!, isStrong: true);
          }

          final text = node.text!;

          if (Utils.textIsTwitterUser(text)) {
            final twitterUsername = Utils.findTwitterUsernameByText(text);
            return TextSpan(
              text: 'Twitter:$twitterUsername',
              style: _knownStrongLinkStyle,
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  if (!await platformAPI.urlLaunch('twitter://user?screen_name=$twitterUsername')) {
                    Log.d('没有Twitter APK');
                    await platformAPI.urlLaunch('https://mobile.twitter.com/$twitterUsername');
                  }
                },
            );
          }

          return TextSpan(
            text: text,
            style: _strongTagStyle ,
          );
        case '<html span>':
          if (node.hasChildNodes()) {
            //忽略span标签的所有属性 (颜色 字体大小等)
            return _buildNode(node.firstChild!, isStrong: true);
          }

          return const TextSpan(text: '');
      }
    }

    return TextSpan(text: node.toString());
  }

  @override
  Widget build(BuildContext context) {
    final htmlDocument = html.parseFragment(widget.htmlString, generateSpans: true);

    if (widget.showOriginal) {
      return Text(widget.htmlString);
    } else {
      return RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 16, color: settingsManager.isLightTheme ? Colors.black : null),
          children: [for (final node in htmlDocument.nodes) _buildNode(node)],
        ),
      );
    }
  }
}
