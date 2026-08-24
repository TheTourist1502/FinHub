# image_cropper's bundled ucrop library optionally references okhttp3 classes
# that aren't a real dependency of this app; suppress R8's missing-class errors.
-dontwarn okhttp3.Call
-dontwarn okhttp3.Dispatcher
-dontwarn okhttp3.OkHttpClient
-dontwarn okhttp3.Request$Builder
-dontwarn okhttp3.Request
-dontwarn okhttp3.Response
-dontwarn okhttp3.ResponseBody
