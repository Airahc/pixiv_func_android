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
import PixivLocalReverseProxy.PixivLocalReverseProxy
import android.util.Log
import androidx.webkit.ProxyConfig
import androidx.webkit.ProxyController
import androidx.webkit.WebViewFeature

@SuppressLint("SetJavaScriptEnabled")
class PlatformWebView(
    context: Context,
    binaryMessenger: BinaryMessenger,
    viewId: Int,
    arguments: Any?
) : PlatformView, MethodChannel.MethodCallHandler, BasicMessageChannel.MessageHandler<Any> {

    private val webView = WebView(context)

    private val useLocalReverseProxy: Boolean =
        (arguments as Map<*, *>)["useLocalReverseProxy"] as Boolean

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





    override fun onFlutterViewAttached(flutterView: View) {
//        Log.i("Info","onFlutterViewAttached")
        if (useLocalReverseProxy) {
            if (WebViewFeature.isFeatureSupported(WebViewFeature.PROXY_OVERRIDE)) {
                PixivLocalReverseProxy.startServer("12345")
                val proxyUrl = "127.0.0.1:12345"
                val proxyConfig: ProxyConfig = ProxyConfig.Builder()
                    .addProxyRule(proxyUrl)
                    .addDirect()
                    .build()
                ProxyController.getInstance().setProxyOverride(
                    proxyConfig,
                    { command -> command?.run() },
                ) {
                    Log.i("PlatformWebView", "Set Proxy")
                }
            }
        }
        super.onFlutterViewAttached(flutterView)
    }

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
        ).setMethodCallHandler(this)
    }

    override fun getView(): View {
        return webView
    }

    override fun dispose() {
//        Log.i("Info","dispose")
        if (useLocalReverseProxy) {
            if (WebViewFeature.isFeatureSupported(WebViewFeature.PROXY_OVERRIDE)) {
                ProxyController.getInstance().clearProxyOverride(
                    { command -> command?.run() },
                ) {
                    Log.i("PlatformWebView", "Clear Proxy")
                }
                PixivLocalReverseProxy.stopServer()
            }

        }
        super.onFlutterViewDetached()
        webView.destroy()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            PlatformWebViewPlugin.methodLoadUrl -> {
                webView.loadUrl(call.argument<String>("url")!!)
            }
            PlatformWebViewPlugin.methodReload -> {
                webView.reload()
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onMessage(message: Any?, reply: BasicMessageChannel.Reply<Any>) {

    }
}