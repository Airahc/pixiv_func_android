/*
 * Copyright (C) 2021. by 小草, All rights reserved
 */

package top.xiaocao.pixiv_xiaocao.login

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class LoginViewFactory(private val messenger: BinaryMessenger) : PlatformViewFactory(
    StandardMessageCodec.INSTANCE
) {

    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        return LoginView(context!!, messenger, viewId, args as Map<String, Any>)
    }
}