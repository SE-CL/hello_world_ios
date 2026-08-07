package com.example.hello_world_ios;

import android.accessibilityservice.AccessibilityServiceInfo;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.provider.Settings;

import androidx.annotation.NonNull;

import org.json.JSONArray;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.view.accessibility.AccessibilityManager;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.secl.hello_world_ios/automation";
    private static final String PREFS = "automation_preferences";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(this::handleMethodCall);
    }

    private void handleMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        SharedPreferences preferences = getSharedPreferences(PREFS, Context.MODE_PRIVATE);
        switch (call.method) {
            case "getStatus":
                Map<String, Boolean> status = new HashMap<>();
                status.put("serviceEnabled", isAutomationServiceEnabled());
                status.put("overlayEnabled", preferences.getBoolean("overlay_enabled", false));
                status.put("running", preferences.getBoolean("running", false));
                result.success(status);
                break;
            case "openAccessibilitySettings":
                startActivity(new Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS));
                result.success(null);
                break;
            case "saveConfiguration":
                try {
                    List<?> points = call.arguments();
                    preferences.edit().putString("points", new JSONArray(points).toString()).apply();
                    result.success(null);
                } catch (Exception exception) {
                    result.error("INVALID_POINTS", "Unable to save click points", exception.getMessage());
                }
                break;
            case "setOverlayEnabled":
                boolean enabled = Boolean.TRUE.equals(call.arguments());
                preferences.edit().putBoolean("overlay_enabled", enabled).apply();
                sendCommand(enabled ? AutoClickAccessibilityService.ACTION_SHOW_OVERLAY : AutoClickAccessibilityService.ACTION_HIDE_OVERLAY);
                result.success(null);
                break;
            case "startAutoClick":
                if (!isAutomationServiceEnabled()) {
                    result.error("SERVICE_DISABLED", "Enable the accessibility service first", null);
                    break;
                }
                sendCommand(AutoClickAccessibilityService.ACTION_START);
                result.success(null);
                break;
            case "stopAutoClick":
                sendCommand(AutoClickAccessibilityService.ACTION_STOP);
                result.success(null);
                break;
            default:
                result.notImplemented();
        }
    }

    private void sendCommand(String action) {
        Intent command = new Intent(this, AutoClickAccessibilityService.class);
        command.setAction(action);
        startService(command);
    }

    private boolean isAutomationServiceEnabled() {
        AccessibilityManager manager = (AccessibilityManager) getSystemService(Context.ACCESSIBILITY_SERVICE);
        for (AccessibilityServiceInfo info : manager.getEnabledAccessibilityServiceList(AccessibilityServiceInfo.FEEDBACK_ALL_MASK)) {
            if (info.getResolveInfo() != null
                    && info.getResolveInfo().serviceInfo != null
                    && getPackageName().equals(info.getResolveInfo().serviceInfo.packageName)
                    && AutoClickAccessibilityService.class.getName().equals(info.getResolveInfo().serviceInfo.name)) {
                return true;
            }
        }
        return false;
    }
}
