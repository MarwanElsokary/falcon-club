package com.falconclubapp.ai

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // سجل الـ engine في cache باسم "my_engine"
        FlutterEngineCache.getInstance().put("my_engine", flutterEngine)

        // احذف أو علّق هذه السطور:
        // flutterEngine
        //     .platformViewsController
        //     .registry
        //     .registerViewFactory(
        //         "native-video-view",
        //         NativeVideoFactory(StandardMessageCodec())
        //     )
    }
}