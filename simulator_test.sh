#!/bin/bash

echo "=== AI卡路里 模拟器测试脚本 ==="
echo ""

echo "1. 可用的模拟器列表："
echo "----------------------------------------"
xcrun simctl list devices | grep -E "iPhone|iPad" | grep -v "unavailable" | head -10
echo ""

SIMULATOR_ID=$(xcrun simctl list devices | grep "iPhone" | grep -v "unavailable" | head -1 | grep -oE "[A-F0-9]{8}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{12}")

if [ -z "$SIMULATOR_ID" ]; then
    echo "错误：没有找到可用的 iPhone 模拟器"
    exit 1
fi

echo "2. 使用模拟器 ID: $SIMULATOR_ID"
echo ""

echo "3. 启动模拟器..."
echo "----------------------------------------"
xcrun simctl boot $SIMULATOR_ID 2>/dev/null || echo "模拟器可能已经启动"
echo ""

echo "4. 等待模拟器完全启动..."
sleep 5

echo "5. 构建并安装应用..."
echo "----------------------------------------"
xcodebuild -scheme AI卡路里 \
           -sdk iphonesimulator \
           -derivedDataPath build \
           -destination "id=$SIMULATOR_ID" \
           build 2>&1 | tail -10

APP_PATH=$(find build/Build/Products -name "AI卡路里.app" -type d | head -1)

if [ -z "$APP_PATH" ]; then
    echo "错误：无法找到构建的应用"
    exit 1
fi

echo ""
echo "6. 应用路径: $APP_PATH"
echo ""

echo "7. 安装应用到模拟器..."
echo "----------------------------------------"
xcrun simctl install $SIMULATOR_ID "$APP_PATH"
echo "安装完成"
echo ""

echo "8. 启动应用..."
echo "----------------------------------------"
xcrun simctl launch $SIMULATOR_ID com.weiproduct.AICalories
echo ""

echo "=== 测试完成 ==="
echo ""
echo "提示："
echo "- 应用应该已经在模拟器中启动"
echo "- 使用 'open -a Simulator' 打开模拟器界面"
echo "- 应用包ID: com.weiproduct.AICalories"