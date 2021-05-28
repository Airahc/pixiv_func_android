/*
 * Copyright (C) 2021. by 小草, All rights reserved
 */

package top.xiaocao.pixiv_xiaocao.login

import android.annotation.SuppressLint
import android.content.Context
import android.os.Build
import android.util.Log
import android.view.View
import android.webkit.CookieManager
import android.webkit.WebSettings
import android.webkit.WebView
import android.webkit.WebViewClient
import io.flutter.plugin.common.*
import io.flutter.plugin.platform.PlatformView

@SuppressLint("SetJavaScriptEnabled")
class LoginView(
    context: Context,
    messenger: BinaryMessenger,
    viewId: Int,
    arguments: Map<String, Any>
) :
    PlatformView, MethodChannel.MethodCallHandler {

    private val webView = WebView(context)
    private val loginResultSender: BasicMessageChannel<Any> =
        BasicMessageChannel(messenger, "pixiv.xiaocao/login_result", StandardMessageCodec())

    init {
        val methodChannel = MethodChannel(
            messenger,
            "pixiv.xiaocao/login_view$viewId"
        )
        methodChannel.setMethodCallHandler(this)
    }


    override fun getView(): View {
        return webView
    }

    override fun dispose() {

    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "do_login" -> {
                doLogin()
                result.success(null)
            }
        }
    }


    private fun doLogin() {
        val cookieManager = CookieManager.getInstance()

        if (Build.VERSION.SDK_INT > Build.VERSION_CODES.LOLLIPOP) {
            cookieManager.removeAllCookies {}
        } else {
            cookieManager.removeAllCookie()
        }

        webView.webViewClient = object : WebViewClient() {
            override fun onPageFinished(view: WebView?, url: String?) {
                url?.let { Log.i("LoginView", it) }
                if (url == "https://www.pixiv.net/") {
                    view?.let { webView ->
                        webView.evaluateJavascript(
                            "JSON.parse(document.getElementById('init-config').getAttribute('content'))"
                        ) {

                            loginResultSender.send(
                                mapOf(
                                    "cookie" to cookieManager.getCookie("https://www.pixiv.net/"),
                                    "initConfig" to it
                                )
                            )
                        }
                    }
                }
                super.onPageFinished(view, url)
            }
        }


        val settings = webView.settings
        settings.javaScriptEnabled = true
        settings.javaScriptCanOpenWindowsAutomatically = true
        settings.cacheMode = WebSettings.LOAD_NO_CACHE

        if (Build.VERSION.SDK_INT > Build.VERSION_CODES.O) {
            settings.safeBrowsingEnabled = false
        }

        webView.loadUrl("https://accounts.pixiv.net/login")

    }
}