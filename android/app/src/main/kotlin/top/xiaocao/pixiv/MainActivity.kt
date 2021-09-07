package top.xiaocao.pixiv
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import top.xiaocao.pixiv.platform.api.PlatformApiPlugin
import top.xiaocao.pixiv.platform.webview.PlatformWebViewPlugin


class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        flutterEngine.plugins.add(PlatformWebViewPlugin())
        flutterEngine.plugins.add(PlatformApiPlugin(context))
    }
}
