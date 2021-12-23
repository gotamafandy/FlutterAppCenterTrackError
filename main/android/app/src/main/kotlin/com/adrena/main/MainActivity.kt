package com.adrena.main

import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {

    override fun onStop() {
        super.onStop()

        throw Exception("CRASH NATIVELY")
    }
}
