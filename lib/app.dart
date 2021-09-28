/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:app.dart
 * 创建时间:2021/8/20 下午12:30
 * 作者:小草
 */
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/ui/widget/refresher_footer.dart';
import 'package:pixiv_func_android/view_model/theme_model.dart';
import 'package:pixiv_func_android/ui/home.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

DateTime? lastPopTime;

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration(
      headerBuilder: () => MaterialClassicHeader(
        backgroundColor: settingsManager.isLightTheme ? const Color(0xff343639) : null,
        color: Provider.of<ThemeModel>(context).currentTheme.colorScheme.primary,
      ),
      footerBuilder: () => const RefresherFooter(),
      hideFooterWhenNotFull: false,
      child: MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('zh', 'CN'),
        ],
        debugShowCheckedModeBanner: false,
        theme: Provider.of<ThemeModel>(context).currentTheme,
        home: WillPopScope(
          onWillPop: () async {
            if (null == lastPopTime || DateTime.now().difference(lastPopTime!) > const Duration(seconds: 1)) {
              lastPopTime = DateTime.now();
              platformAPI.toast('再按一次退出');
              return false;
            } else {
              return true;
            }
          },
          child: const Home(),
        ),
      ),
    );
  }
}
