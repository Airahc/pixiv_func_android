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

//必须是StatefulWidget才能响应点击事件
class HtmlRichText extends StatefulWidget {
  final String htmlString;

  const HtmlRichText(this.htmlString, {Key? key}) : super(key: key);
  @override
  _HtmlRichTextState createState() => _HtmlRichTextState();
}

class _HtmlRichTextState extends State<HtmlRichText> {


  static const _A_TAG_STYLE = TextStyle(color: Colors.blue);
  static const _STRONG_TAG_STYLE = TextStyle(fontSize: 25);

  TextSpan _buildNode(html.Node node) {
    if (node.nodeType == html.Node.TEXT_NODE) {
      return TextSpan(text: node.text);
    } else if (node.nodeType == html.Node.ELEMENT_NODE) {
      switch (node.toString()) {
        case '<html br>':
          return TextSpan(text: '\n');
        case '<html a>':
          return TextSpan(
              text: node.text,
              style: _A_TAG_STYLE,
              recognizer: LongPressGestureRecognizer()
                ..onLongPress = () {
                  print('点击了a标签的连接:${node.text}');
                });
        case '<html strong>':
          return TextSpan(text: node.text, style: _STRONG_TAG_STYLE);
      }
    }

    return TextSpan(text: node.toString());
  }

  @override
  Widget build(BuildContext context) {
    final htmlDocument = html.parseFragment(widget.htmlString, generateSpans: true);

    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyText1,
        children: htmlDocument.nodes.map((node) => _buildNode(node)).toList(),
      ),
    );
  }
}


