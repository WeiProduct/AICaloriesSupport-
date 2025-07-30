#!/bin/bash

echo "=== 重置语言选择 ==="
echo ""

SIMULATOR_ID="36CE8970-81F7-4F06-96D0-B22F731B36AC"
APP_ID="com.weiproduct.AICalories"

APP_CONTAINER=$(xcrun simctl get_app_container $SIMULATOR_ID $APP_ID data 2>/dev/null)

if [ -z "$APP_CONTAINER" ]; then
    echo "错误：无法找到应用容器"
    exit 1
fi

echo "应用容器路径: $APP_CONTAINER"
echo ""

echo "清除 UserDefaults..."
rm -f "$APP_CONTAINER/Library/Preferences/${APP_ID}.plist"

echo "终止应用..."
xcrun simctl terminate $SIMULATOR_ID $APP_ID 2>/dev/null

echo ""
echo "✅ 语言选择已重置"
echo ""
echo "重新启动应用将显示语言选择页面"