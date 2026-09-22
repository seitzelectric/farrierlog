package com.seitzelectric.farrierlog

import android.os.Bundle
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // FlutterActivity doesn't extend androidx.activity.ComponentActivity,
        // so the enableEdgeToEdge() extension isn't applicable here; this is
        // the equivalent low-level call for edge-to-edge on Android 15+.
        WindowCompat.setDecorFitsSystemWindows(window, false)
    }
}
