package skglobal.product.flutter_uv_blind_refactor.methodchannels;

import android.net.Uri;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;

public class DeeplinkMethodChannel {
    private MethodChannel channel;

    private DeeplinkMethodChannel() {
    }

    public static DeeplinkMethodChannel getInstance() {
        return SingletonHelper.INSTANCE;
    }

    public void register(BinaryMessenger messenger) {
        channel = new MethodChannel(messenger, "uv_deeplink");
        channel.setMethodCallHandler(handler);
    }

    private final MethodChannel.MethodCallHandler handler = (call, result) -> result.notImplemented();

    public void openLink(Uri uri) {
        if (uri != null) {
            channel.invokeMethod("open_link", uri.toString());
        }
    }

    private static class SingletonHelper {
        private static final DeeplinkMethodChannel INSTANCE = new DeeplinkMethodChannel();
    }
}