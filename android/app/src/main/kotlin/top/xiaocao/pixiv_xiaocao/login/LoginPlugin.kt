/*
 * Copyright (C) 2021. by 小草, All rights reserved
 */

package top.xiaocao.pixiv_xiaocao.login

import io.flutter.embedding.engine.plugins.FlutterPlugin

class LoginPlugin : FlutterPlugin {
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        val binaryMessenger = binding.binaryMessenger
        binding.platformViewRegistry.registerViewFactory(
            "pixiv.xiaocao/login_view",
            LoginViewFactory(binaryMessenger)
        )

    }

    companion object {
        @JvmStatic
        fun registerWith(registry: io.flutter.plugin.common.PluginRegistry.Registrar) {
            registry.platformViewRegistry().registerViewFactory(
                "pixiv.xiaocao/login_view",
                LoginViewFactory(registry.messenger())
            )
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {

    }


}