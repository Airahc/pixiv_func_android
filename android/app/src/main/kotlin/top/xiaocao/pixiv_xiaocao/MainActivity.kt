package top.xiaocao.pixiv_xiaocao

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant.*

class MainActivity : FlutterActivity() {

    private val channelName = "android/platform/api"

    private val eventBackToDesktop = "backDesktop"

    private val eventBackgroundRun = "backgroundRun"

    private val eventSaveImage = "saveImage"

    private val eventImageIsExist = "imageIsExist"


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        registerWith(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channelName
        ).setMethodCallHandler { methodCall, result ->
            when (methodCall.method) {
                eventBackToDesktop -> {
                    moveTaskToBack(false)
                    result.success(null)
                }
                eventBackgroundRun -> {
                    moveTaskToBack(true)
                    result.success(null)
                }
                eventSaveImage -> {
                    result.success(
                        saveImage(
                            imageBytes = methodCall.argument<ByteArray>("imageBytes")!!,
                            fileName = methodCall.argument<String>("fileName")!!
                        )
                    )
                }
                eventImageIsExist -> {
                    result.success(imageExist(fileName = methodCall.argument<String>("fileName")!!))
                }
                else -> {
                    result.notImplemented()
                }
            }
        }


    }
}

