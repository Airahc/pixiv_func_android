/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:Zip.kt
 * 创建时间:2021/9/12 下午6:26
 * 作者:小草
 */

package top.xiaocao.pixiv.util

import java.util.zip.ZipEntry
import java.util.zip.ZipInputStream

fun ZipInputStream.forEachEntry(action: (entry: ZipEntry) -> Unit) {
    var zipEntry: ZipEntry?
    while (
        this.run {
            zipEntry = this.nextEntry
            null != zipEntry
        }
    ) {
        zipEntry?.let { action(it) }
    }
}