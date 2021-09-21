/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:PlatformWebView.kt
 * 创建时间:2021/9/5 下午4:49
 * 作者:小草
 */

package top.xiaocao.pixiv.platform.webview

import android.annotation.SuppressLint
import android.content.Context
import android.net.http.SslError
import android.view.View
import android.webkit.*
import io.flutter.plugin.common.*
import io.flutter.plugin.platform.PlatformView

@SuppressLint("SetJavaScriptEnabled")
class PlatformWebView(
    context: Context,
    binaryMessenger: BinaryMessenger,
    viewId: Int,
    arguments: Any?
) : PlatformView, MethodChannel.MethodCallHandler, BasicMessageChannel.MessageHandler<Any> {

    private val webView = WebView(context)

    private val messageChannel: BasicMessageChannel<Any> =
        BasicMessageChannel(
            binaryMessenger,
            "${PlatformWebViewPlugin.pluginName}/result",
            StandardMessageCodec()
        )
    private val progressMessageChannel: BasicMessageChannel<Any> =
        BasicMessageChannel(
            binaryMessenger,
            "${PlatformWebViewPlugin.pluginName}/progress",
            StandardMessageCodec()
        )


    init {
        webView.settings.apply {
            javaScriptEnabled = true
            javaScriptCanOpenWindowsAutomatically = true
        }

        webView.webViewClient = object : WebViewClient() {

            @SuppressLint("WebViewClientOnReceivedSslError")
            override fun onReceivedSslError(
                view: WebView?,
                handler: SslErrorHandler?,
                error: SslError?
            ) {
                handler?.proceed()
            }

            override fun shouldOverrideUrlLoading(
                view: WebView?,
                request: WebResourceRequest?
            ): Boolean {
                request?.let {
                    val uri = it.url

                    if ("pixiv" == uri.scheme) {

                        val host = uri.host
                        if (null != host && host.contains("account")) {

                            try {
                                messageChannel.send(
                                    mapOf(
                                        "type" to "code",
                                        "content" to uri.getQueryParameter("code")
                                    )
                                )

                            } catch (e: Exception) {
                            }
                        }
                        return true
                    }


                }
                return super.shouldOverrideUrlLoading(view, request)
            }

            override fun onPageFinished(view: WebView?, url: String?) {
                view?.apply {
                    evaluateJavascript(
                        "document.querySelectorAll('input').forEach((current)=>{\n" +
                                "            if('password' === current.type){\n" +
                                "            current.type='text';\n" +
                                "            }\n" +
                                "            });"
                    ) {

                    }
                }
                super.onPageFinished(view, url)
            }
        }

        webView.webChromeClient = object : WebChromeClient() {
            override fun onProgressChanged(view: WebView?, newProgress: Int) {
                progressMessageChannel.send(newProgress)
                super.onProgressChanged(view, newProgress)

            }
        }

        MethodChannel(
            binaryMessenger,
            "${PlatformWebViewPlugin.pluginName}$viewId"
        ).also { it.setMethodCallHandler(this) }
    }

    override fun getView(): View {
        return webView
    }

    override fun dispose() {
        webView.destroy()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            PlatformWebViewPlugin.methodLoadUrl -> {
                webView.loadUrl(call.argument<String>("url")!!)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onMessage(message: Any?, reply: BasicMessageChannel.Reply<Any>) {

    }
}