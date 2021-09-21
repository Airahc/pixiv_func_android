/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:PlatformWebViewPlugin.kt
 * 创建时间:2021/9/5 下午4:49
 * 作者:小草
 */

package top.xiaocao.pixiv.platform.webview


import io.flutter.embedding.engine.plugins.FlutterPlugin

class PlatformWebViewPlugin : FlutterPlugin {

    companion object {
        const val pluginName = "xiaocao/platform/web_view"

        const val methodLoadUrl = "loadUrl"
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        binding.platformViewRegistry.registerViewFactory(
            pluginName,
            PlatformWebViewFactory(binding.binaryMessenger)
        )

    }


    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {

    }
}