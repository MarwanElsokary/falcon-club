package com.falconclubapp.ai

import android.content.Context
import com.google.android.exoplayer2.upstream.cache.SimpleCache
import com.google.android.exoplayer2.upstream.cache.LeastRecentlyUsedCacheEvictor
import com.google.android.exoplayer2.database.ExoDatabaseProvider
import java.io.File

object VideoCache {
    private var instance: SimpleCache? = null

    fun getInstance(context: Context): SimpleCache {
        if (instance == null) {
            val cacheDir = File(context.cacheDir, "video_cache")
            val evictor = LeastRecentlyUsedCacheEvictor(100 * 1024 * 1024) // 100MB
            instance = SimpleCache(cacheDir, evictor, ExoDatabaseProvider(context))
        }
        return instance!!
    }
}
