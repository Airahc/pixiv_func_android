/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_android
 * 文件名称:about_page.dart
 * 创建时间:2021/9/6 下午6:57
 * 作者:小草
 */
import 'package:flutter/material.dart';
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/model/release_info.dart';
import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/provider/view_state.dart';
import 'package:pixiv_func_android/ui/widget/html_rich_text.dart';
import 'package:pixiv_func_android/view_model/about_model.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  static const thisProjectGitHubUrl = 'https://github.com/xiao-cao-x/pixiv-func-android';

  Widget _buildReleaseInfo(ReleaseInfo info) {
    return Column(
      children: [
        ListTile(
          title: Text('最新发行版 ${info.tagName}'),
        ),
        Card(
          child: Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.topLeft,
            child: HtmlRichText(info.body),
          ),
        ),
        Card(
          child: ListTile(
            onTap: () async {

              if (!await platformAPI.urlLaunch(info.htmlUrl)) {
                platformAPI.toast('打开浏览器失败');
              }
            },
            title: Text('打开标签页'),
            subtitle: Text('前往外部浏览器'),
          ),
        ),
        Card(
          child: ListTile(
            onTap: () async {
              if (!await platformAPI.urlLaunch(info.browserDownloadUrl)) {
                platformAPI.toast('打开浏览器失败');
              }
            },
            title: Text('点击下载最新版本'),
            subtitle: Text('前往外部浏览器'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      model: AboutModel(),
      builder: (BuildContext context, AboutModel model, Widget? child) {
        final Widget releaseInfoWidget;
        if (ViewState.Busy == model.viewState) {
          releaseInfoWidget = Container(
            padding: EdgeInsets.all(20),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (ViewState.Idle == model.viewState) {
          if (null == model.releaseInfo) {
            releaseInfoWidget = Container();
          } else {
            releaseInfoWidget = _buildReleaseInfo(model.releaseInfo!);
          }
        } else if (ViewState.InitFailed == model.viewState) {
          releaseInfoWidget = ListTile(
            onTap: model.loadLatestReleaseInfo,
            title: Center(
              child: Text('加载失败发行版信息失败,点击重新加载'),
            ),
          );
        } else {
          releaseInfoWidget = Container();
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('关于'),
          ),
          body: ListView(
            children: [
              ListTile(
                leading: Image.asset(
                  'assets/xiaocao.png',
                  width: 50,
                ),
                title: Text('这是小草的个人玩具项目'),
                subtitle: Text('夹批搪与牲口不得使用此软件'),
              ),
              Divider(),
              Card(
                margin: EdgeInsets.all(0),
                child: ListTile(
                  onTap: () async {
                    if (!await platformAPI.urlLaunch(thisProjectGitHubUrl)) {
                      platformAPI.toast('打开浏览器失败');
                    }
                  },
                  title: Text(thisProjectGitHubUrl),
                  subtitle: Text('项目地址(点击前往)'),
                ),
              ),
              Divider(),
              ListTile(
                title: Row(
                  children: [
                    Text('该软件使用'),
                    Image.asset(
                      'assets/dart-logo.png',
                      width: 30,
                      height: 30,
                    ),
                    Text('与'),
                    Image.asset(
                      'assets/kotlin-logo.png',
                      width: 30,
                      height: 30,
                    ),
                    Text('开发 开源且免费'),
                  ],
                ),
                subtitle: Text('禁止用于商业用途(包括收取打赏)'),
              ),
              Divider(),
              ListTile(
                title: Text('该项目与一切现有同类项目无关'),
                subtitle: Text('请不要拿来比较'),
              ),
              Divider(),
              ListTile(
                title: Text('当前版本:${null != model.appVersion ? model.appVersion! : '正在获取...'}'),
              ),
              Divider(),
              releaseInfoWidget,
            ],
          ),
        );
      },
      onModelReady: (AboutModel model) async {
        await model.loadAppVersion();
        model.loadLatestReleaseInfo();
      },
    );
  }
}
