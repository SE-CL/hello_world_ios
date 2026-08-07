package com.example.hello_world_ios;

import android.accessibilityservice.AccessibilityService;
import android.accessibilityservice.GestureDescription;
import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.Color;
import android.graphics.Path;
import android.graphics.PixelFormat;
import android.graphics.drawable.GradientDrawable;
import android.os.Handler;
import android.os.Looper;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.WindowManager;
import android.view.accessibility.AccessibilityEvent;
import android.widget.TextView;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

public class AutoClickAccessibilityService extends AccessibilityService {
    public static final String ACTION_START = "com.example.hello_world_ios.START";
    public static final String ACTION_STOP = "com.example.hello_world_ios.STOP";
    public static final String ACTION_SHOW_OVERLAY = "com.example.hello_world_ios.SHOW_OVERLAY";
    public static final String ACTION_HIDE_OVERLAY = "com.example.hello_world_ios.HIDE_OVERLAY";

    private static final String PREFS = "automation_preferences";
    private final Handler handler = new Handler(Looper.getMainLooper());
    private final List<ClickPoint> points = new ArrayList<>();
    private WindowManager windowManager;
    private TextView overlay;
    private boolean running;
    private int nextPointIndex;

    @Override
    protected void onServiceConnected() {
        super.onServiceConnected();
        windowManager = (WindowManager) getSystemService(WINDOW_SERVICE);
        if (preferences().getBoolean("overlay_enabled", false)) {
            showOverlay();
        }
    }

    @Override
    public int onStartCommand(android.content.Intent intent, int flags, int startId) {
        if (intent != null && intent.getAction() != null) {
            handleCommand(intent.getAction());
        }
        return START_NOT_STICKY;
    }

    private void handleCommand(String action) {
        if (ACTION_START.equals(action)) {
            startAutomation();
        } else if (ACTION_STOP.equals(action)) {
            stopAutomation();
        } else if (ACTION_SHOW_OVERLAY.equals(action)) {
            showOverlay();
        } else if (ACTION_HIDE_OVERLAY.equals(action)) {
            hideOverlay();
        }
    }

    private void startAutomation() {
        readPoints();
        if (points.isEmpty()) return;
        running = true;
        nextPointIndex = 0;
        preferences().edit().putBoolean("running", true).apply();
        updateOverlayLabel();
        performNextClick();
    }

    private void stopAutomation() {
        running = false;
        handler.removeCallbacksAndMessages(null);
        preferences().edit().putBoolean("running", false).apply();
        updateOverlayLabel();
    }

    private void readPoints() {
        points.clear();
        try {
            JSONArray saved = new JSONArray(preferences().getString("points", "[]"));
            for (int index = 0; index < saved.length() && index < 10; index++) {
                JSONObject point = saved.getJSONObject(index);
                points.add(new ClickPoint(
                        point.optInt("x", 500),
                        point.optInt("y", 500),
                        Math.max(1, Math.min(10, point.optInt("rate", 1))),
                        Math.max(1, Math.min(10, point.optInt("priority", 5)))));
            }
            Collections.sort(points, Comparator.comparingInt((ClickPoint point) -> point.priority).reversed());
        } catch (Exception ignored) {
            points.clear();
        }
    }

    private void performNextClick() {
        if (!running || points.isEmpty()) return;
        ClickPoint point = points.get(nextPointIndex++ % points.size());
        int screenWidth = getResources().getDisplayMetrics().widthPixels;
        int screenHeight = getResources().getDisplayMetrics().heightPixels;
        float x = screenWidth * point.x / 1000f;
        float y = screenHeight * point.y / 1000f;

        Path path = new Path();
        path.moveTo(x, y);
        GestureDescription gesture = new GestureDescription.Builder()
                .addStroke(new GestureDescription.StrokeDescription(path, 0, 40))
                .build();

        dispatchGesture(gesture, new GestureResultCallback() {
            @Override
            public void onCompleted(GestureDescription gestureDescription) {
                int delay = Math.max(1, 1000 / point.rate - 40);
                handler.postDelayed(AutoClickAccessibilityService.this::performNextClick, delay);
            }

            @Override
            public void onCancelled(GestureDescription gestureDescription) {
                handler.postDelayed(AutoClickAccessibilityService.this::performNextClick, 150);
            }
        }, null);
    }

    private void showOverlay() {
        if (overlay != null || windowManager == null) return;
        overlay = new TextView(this);
        overlay.setTextColor(Color.WHITE);
        overlay.setTextSize(22);
        overlay.setGravity(Gravity.CENTER);
        overlay.setPadding(14, 8, 14, 8);
        GradientDrawable background = new GradientDrawable();
        background.setColor(Color.rgb(108, 99, 255));
        background.setShape(GradientDrawable.OVAL);
        overlay.setBackground(background);
        updateOverlayLabel();

        int bubbleSize = Math.round(56 * getResources().getDisplayMetrics().density);
        WindowManager.LayoutParams params = new WindowManager.LayoutParams(
                bubbleSize, bubbleSize,
                WindowManager.LayoutParams.TYPE_ACCESSIBILITY_OVERLAY,
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE | WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN,
                PixelFormat.TRANSLUCENT);
        params.gravity = Gravity.TOP | Gravity.START;
        params.x = 16;
        params.y = 160;
        overlay.setOnTouchListener(new DragTouchListener(params));
        windowManager.addView(overlay, params);
    }

    private void updateOverlayLabel() {
        if (overlay != null) {
            overlay.setText(running ? "■" : "▶");
        }
    }

    private void hideOverlay() {
        if (overlay != null && windowManager != null) {
            windowManager.removeView(overlay);
            overlay = null;
        }
    }

    private SharedPreferences preferences() {
        return getSharedPreferences(PREFS, Context.MODE_PRIVATE);
    }

    @Override
    public void onAccessibilityEvent(AccessibilityEvent event) {
        // Gestures are dispatched only after an explicit user action in this app.
    }

    @Override
    public void onInterrupt() {
        stopAutomation();
    }

    @Override
    public void onDestroy() {
        stopAutomation();
        hideOverlay();
        super.onDestroy();
    }

    private final class DragTouchListener implements View.OnTouchListener {
        private final WindowManager.LayoutParams params;
        private float downX;
        private float downY;
        private int startX;
        private int startY;
        private boolean moved;

        DragTouchListener(WindowManager.LayoutParams params) {
            this.params = params;
        }

        @Override
        public boolean onTouch(View view, MotionEvent event) {
            if (event.getAction() == MotionEvent.ACTION_DOWN) {
                downX = event.getRawX();
                downY = event.getRawY();
                startX = params.x;
                startY = params.y;
                moved = false;
                return true;
            }
            if (event.getAction() == MotionEvent.ACTION_MOVE) {
                float distanceX = event.getRawX() - downX;
                float distanceY = event.getRawY() - downY;
                moved = Math.abs(distanceX) > 8 || Math.abs(distanceY) > 8;
                params.x = startX + (int) distanceX;
                params.y = startY + (int) distanceY;
                windowManager.updateViewLayout(overlay, params);
                return true;
            }
            if (event.getAction() == MotionEvent.ACTION_UP && !moved) {
                if (running) stopAutomation(); else startAutomation();
                return true;
            }
            return true;
        }
    }

    private static final class ClickPoint {
        final int x;
        final int y;
        final int rate;
        final int priority;

        ClickPoint(int x, int y, int rate, int priority) {
            this.x = Math.max(0, Math.min(1000, x));
            this.y = Math.max(0, Math.min(1000, y));
            this.rate = rate;
            this.priority = priority;
        }
    }
}
