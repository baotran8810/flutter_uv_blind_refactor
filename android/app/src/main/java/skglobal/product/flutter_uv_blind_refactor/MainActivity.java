package skglobal.product.flutter_uv_blind_refactor;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.PersistableBundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import org.jetbrains.annotations.NotNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import skglobal.product.flutter_uv_blind_refactor.methodchannels.DeeplinkMethodChannel;

import android.accessibilityservice.AccessibilityServiceInfo;
import android.content.Context;
import android.os.Build;
import android.text.TextUtils;
import android.view.accessibility.AccessibilityManager;
import androidx.annotation.NonNull;

import com.google.android.datatransport.runtime.logging.Logging;

import java.util.List;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "SKG.univoice.dev/talkback";
    @Override
    public void onCreate(@Nullable Bundle savedInstanceState, @Nullable PersistableBundle persistentState) {
        super.onCreate(savedInstanceState, persistentState);
        handleIntent(getIntent());
    }

    @Override
    protected void onNewIntent(@NonNull @NotNull Intent intent) {
        super.onNewIntent(intent);
        handleIntent(intent);
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        DeeplinkMethodChannel.getInstance().register(flutterEngine.getDartExecutor().getBinaryMessenger());
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            // TODO
                            if (call.method.equals("checkTalkBack")) {
                                result.success(accessibilityEnable(getApplication().getApplicationContext()));
                            }
                        }
                );
    }

    private static final String TALKBACK_NAME = "com.android.talkback.TalkBackPreferencesActivity";
    private static final String SAMSUNG_TALKBACK_NAME = "com.samsung.accessibility.Activities$TalkBackPreferencesActivity";
    private static final String SAMSUNG_TALKBACK2_NAME = "com.samsung.android.accessibility.talkback.TalkBackPreferencesActivity";

    public static boolean accessibilityEnable(Context context) {
        boolean enable = false;
        try {
            AccessibilityManager manager = (AccessibilityManager) context.getSystemService(Context.ACCESSIBILITY_SERVICE);
            List<AccessibilityServiceInfo> serviceList = manager.getEnabledAccessibilityServiceList(AccessibilityServiceInfo.FEEDBACK_SPOKEN);
            for (AccessibilityServiceInfo serviceInfo : serviceList) {
                String name = serviceInfo.getSettingsActivityName();
                android.util.Log.d("services", "accessibilityEnable: " + name);
                if (!TextUtils.isEmpty(name)) {
                    if (name.equals(TALKBACK_NAME) || name.equals(SAMSUNG_TALKBACK_NAME) || name.equals(SAMSUNG_TALKBACK2_NAME)) {
                        enable = true;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return enable;
    }

    private void handleIntent(Intent intent) {
        Uri appLinkData = intent.getData();
        DeeplinkMethodChannel.getInstance().openLink(appLinkData);

    }
}

