package com.finhub.mobile

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.android.RenderMode

// local_auth requires a FlutterFragmentActivity (not the base FlutterActivity)
// for the Android biometric prompt dialog to work.
//
// Renders via TextureView instead of the default SurfaceView: SurfaceView can
// fail to reattach cleanly when an external Activity (e.g. the document
// picker DocumentUploadCard launches) takes the foreground and hands control
// back, leaving a stale frame on screen — seen as `BLASTBufferQueue: Can't
// acquire next buffer` in logcat right after returning from the picker.
// TextureView avoids that reattachment path at a small compositing cost.
class MainActivity : FlutterFragmentActivity() {
    override fun getRenderMode(): RenderMode = RenderMode.texture
}
