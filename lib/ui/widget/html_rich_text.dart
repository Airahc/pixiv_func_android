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
  static const _A_TAG_STYLE = TextStyle(color: Colors.blue);
  static const _STRONG_TAG_STYLE = TextStyle(fontSize: 25);
  static const _KNOWN_STRONG_LINK_STYLE = TextStyle(fontSize: 25, color: Colors.pinkAccent);
  static const _KNOWN_LINK_STYLE = TextStyle(color: Colors.pinkAccent);

  TextSpan _buildNode(html.Node node) {
    if (node.nodeType == html.Node.TEXT_NODE) {
      return TextSpan(text: node.text);
    } else if (node.nodeType == html.Node.ELEMENT_NODE) {
      switch (node.toString()) {
        case '<html br>':
          return TextSpan(text: '\n');
        case '<html a>':
          final text = node.text!;

          if (Utils.urlIsTwitter(text)) {
            final twitterUsername = Utils.findTwitterUsernameByUrl(text);
            return TextSpan(
              text: 'Twitter:$twitterUsername',
              style: _KNOWN_LINK_STYLE,
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  if (!await platformAPI.urlLaunch('twitter://user?screen_name=$text')) {
                    print('没有Twitter APK');
                    await platformAPI.urlLaunch(text);
                  }
                },
            );
          }
          if (Utils.urlIsIllust(text)) {
            final illustId = Utils.findIllustIdByUrl(text);
            return TextSpan(
              text: '插画ID:$illustId',
              style: _KNOWN_LINK_STYLE,
              recognizer: TapGestureRecognizer()..onTap = () {},
            );
          }
          if (Utils.urlIsUser(text)) {
            final userId = Utils.findUserIdByUrl(text);
            return TextSpan(
              text: '用户ID:$userId',
              style: _KNOWN_LINK_STYLE,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  PageUtils.to(context, UserPage(userId));
                },
            );
          }

          return TextSpan(
            text: text,
            style: _A_TAG_STYLE,
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                await platformAPI.urlLaunch(text);
              },
          );

        case '<html strong>':
          final text = node.text!;

          if (Utils.textIsTwitterUser(text)) {
            final twitterUsername = Utils.findTwitterUsernameByText(text);
            return TextSpan(
              text: 'Twitter:$twitterUsername',
              style: _KNOWN_STRONG_LINK_STYLE,
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  if (!await platformAPI.urlLaunch('twitter://user?screen_name=$twitterUsername')) {
                    print('没有Twitter APK');
                    await platformAPI.urlLaunch('https://mobile.twitter.com/$twitterUsername');
                  }
                },
            );
          }

          return TextSpan(text: text, style: _STRONG_TAG_STYLE);
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
          style: TextStyle(fontSize: 16),
          children: htmlDocument.nodes.map((node) => _buildNode(node)).toList(),
        ),
      );
    }
  }
}
