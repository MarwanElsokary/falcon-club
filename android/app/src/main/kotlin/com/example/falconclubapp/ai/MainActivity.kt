package com.falconclubapp.ai

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        FlutterEngineCache.getInstance().put("my_engine", flutterEngine)

        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory(
                "native-video-view",
                NativeVideoFactory(flutterEngine.dartExecutor.binaryMessenger, applicationContext)
            )
    }
}