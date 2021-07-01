/*
 * Copyright (C) 2021. by 小草, All rights reserved
 */

package top.xiaocao.pixiv_xiaocao

import android.content.ContentValues
import android.content.Context
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import android.webkit.MimeTypeMap
import java.io.File


fun Context.saveImage(imageBytes: ByteArray, fileName: String): Boolean? {

    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {

        val saveDirectory = File(
            Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES),
            "pixiv_xiaocao"
        )


        val imageFile = File("${saveDirectory.absolutePath}/$fileName")

        val parent = imageFile.parentFile ?: return false

        //目录不存在就创建
        if (!parent.exists() && !parent.mkdirs()) {
            return false
        }

        //文件已经存在
        if (imageFile.exists()) {
            return null
        }

        imageFile.outputStream().use {
            it.write(imageBytes)
        }
        return true
    }
    if (imageExist(fileName)) {
        return null
    }

    val values = ContentValues()
    //文件名
    values.put(MediaStore.MediaColumns.DISPLAY_NAME, fileName)

    values.put(
        MediaStore.MediaColumns.MIME_TYPE,
        MimeTypeMap.getSingleton().getMimeTypeFromExtension(fileName)
    )

    //相册目录
    values.put(
        MediaStore.MediaColumns.RELATIVE_PATH,
        "${Environment.DIRECTORY_PICTURES}/pixiv_xiaocao"
    )

    var uri: Uri? = null
    try {
        //文件存在会被重命名成 $fileName(1)
        uri = contentResolver.insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, values)
        contentResolver.openOutputStream(uri!!)?.use {
            it.write(imageBytes)
        }
    } catch (e: Exception) {
        uri?.let { contentResolver.delete(it, null, null) }
        return false
    }
    return true
}

fun Context.imageExist(fileName: String): Boolean {
    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
        val saveDirectory =
            File(
                Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES),
                "pixiv_xiaocao"
            )

        return saveDirectory.exists() && File("${saveDirectory.absolutePath}/$fileName").exists()
    }

    val where =
        "${MediaStore.Images.Media.RELATIVE_PATH} LIKE ? AND ${MediaStore.Images.Media.DISPLAY_NAME} = ?"

    val args = arrayOf(
        "%${Environment.DIRECTORY_PICTURES}/pixiv_xiaocao%",
        fileName,
    )

    contentResolver.query(
        MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
        arrayOf(MediaStore.Images.Media._ID),
        where,
        args,
        //不排序
        null
    )?.use { cursor ->
        while (cursor.moveToNext()) {
            return true
        }
    }

    return false
}
