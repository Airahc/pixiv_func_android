/*
 * Copyright (C) 2021. by 小草, All rights reserved
 */


package top.xiaocao.pixiv_xiaocao

import android.content.Context
import android.os.Build
import android.os.Environment


fun Context.dataPath(): String {
    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.N) {
        return Environment.getDataDirectory().absolutePath
    }
    return dataDir.absolutePath
}