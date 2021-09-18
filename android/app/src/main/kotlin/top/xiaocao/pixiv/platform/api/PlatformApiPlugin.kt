/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_android
 * 文件名称:PlatformApiPlugin.kt
 * 创建时间:2021/9/5 下午4:48
 * 作者:小草
 */

package top.xiaocao.pixiv.platform.api

import android.annotation.SuppressLint
import android.content.Context
import android.content.Intent
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.Build
import android.widget.Toast
import com.waynejo.androidndkgif.GifEncoder
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import top.xiaocao.pixiv.util.forEachEntry
import top.xiaocao.pixiv.util.imageIsExist
import top.xiaocao.pixiv.util.saveImage
import java.io.ByteArrayInputStream
import java.io.File
import java.util.zip.ZipInputStream

@SuppressLint("ShowToast")
class PlatformApiPlugin(private val context: Context) : FlutterPlugin,
    MethodChannel.MethodCallHandler {
    private val pluginName = "xiaocao/platform/api"

    private val methodImageIsExist = "imageIsExist"
    private val methodSaveImage = "saveImage"
    private val methodToast = "toast"
    private val methodGetBuildVersion = "getBuildVersion"
    private val methodGetAppVersion = "getAppVersion"
    private val methodUrlLaunch = "urlLaunch"
    private val methodGenerateGif = "generateGif"


    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        MethodChannel(
            binding.binaryMessenger,
            pluginName
        ).also {
            it.setMethodCallHandler(this)
        }

    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {

    }


    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            methodImageIsExist -> {
                result.success(
                    context.imageIsExist(
                        filename = call.argument<String>("filename")!!
                    )
                )
            }
            methodSaveImage -> {
                result.success(
                    context.saveImage(
                        imageBytes = call.argument<ByteArray>("imageBytes")!!,
                        filename = call.argument<String>("filename")!!
                    )
                )
            }
            methodToast -> {
                Toast.makeText(
                    context,
                    call.argument<String>("content")!!,
                    if (call.argument<Boolean>("isLong")!!)
                        Toast.LENGTH_LONG
                    else
                        Toast.LENGTH_SHORT,
                ).show()
                result.success(true)
            }
            methodGetBuildVersion -> {
                result.success(Build.VERSION.SDK_INT)
            }
            methodGetAppVersion -> {
                result.success(
                    context.packageManager.getPackageInfo(
                        context.packageName,
                        0
                    ).versionName
                )
            }
            methodUrlLaunch -> {
                try {
                    val intent =
                        Intent(Intent.ACTION_VIEW, Uri.parse(call.argument<String>("url")!!))
                    context.startActivity(intent)
                    result.success(true)
                } catch (e: Exception) {
                    result.success(false)
                }
            }
            methodGenerateGif -> {
                val id = call.argument<Int>("id")
                val zipBytes = call.argument<ByteArray>("zipBytes")!!
                val width = call.argument<Int>("width")!!
                val height = call.argument<Int>("height")!!
                val delays = call.argument<IntArray>("delays")!!

                val gifFile = File(context.externalCacheDir, "$id.gif")

                val gifEncoder = GifEncoder()
                gifEncoder.init(
                    width,
                    height,
                    gifFile.absolutePath,
                    GifEncoder.EncodingType.ENCODING_TYPE_FAST
                )

                var index = 0
                ByteArrayInputStream(zipBytes).use { byteArrayInputStream ->
                    ZipInputStream(byteArrayInputStream).use { zipInputStream ->
                        zipInputStream.forEachEntry {
                            val imageBytes = zipInputStream.readBytes()
                            val bitmap =
                                BitmapFactory.decodeByteArray(
                                    imageBytes,
                                    0,
                                    imageBytes.size,
                                )
                            gifEncoder.encodeFrame(bitmap, delays[index++])
                        }
                    }
                    gifEncoder.close()
                }
                result.success(gifFile.readBytes())
            }
            else -> {
                result.notImplemented()
            }
        }

    }

}