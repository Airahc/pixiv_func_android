package top.xiaocao.pixiv_xiaocao.login

import android.webkit.*
import io.flutter.plugin.common.MethodChannel

class MyWebViewClient(private val result: MethodChannel.Result) : WebViewClient() {

    override fun onPageFinished(view: WebView?, url: String?) {
        if (url == "https://www.pixiv.net/") {
            view?.let { webView ->
                webView.evaluateJavascript(
                    "JSON.parse(document.getElementById('init-config').getAttribute('content'))"
                ) {
                    val cookieManager = CookieManager.getInstance()
                    result.success(
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

//2802083538@qq.com
//Grass666.


}