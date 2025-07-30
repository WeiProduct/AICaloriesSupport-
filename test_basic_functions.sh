#!/bin/bash

echo "=== AI卡路里 基础功能测试 ==="
echo ""
SIMULATOR_ID="36CE8970-81F7-4F06-96D0-B22F731B36AC"

echo "1. 检查应用状态..."
APP_PID=$(xcrun simctl spawn $SIMULATOR_ID launchctl list | grep com.weiproduct.AICalories | awk '{print $1}')
if [ ! -z "$APP_PID" ] && [ "$APP_PID" != "-" ]; then
    echo "✅ 应用正在运行 (PID: $APP_PID)"
else
    echo "❌ 应用未运行"
    exit 1
fi
echo ""

echo "2. 截取当前界面..."
xcrun simctl io $SIMULATOR_ID screenshot app_screenshot.png
echo "✅ 截图保存为: app_screenshot.png"
echo ""

echo "3. 检查应用数据..."
APP_CONTAINER=$(xcrun simctl get_app_container $SIMULATOR_ID com.weiproduct.AICalories data)
echo "应用数据路径: $APP_CONTAINER"
echo ""

echo "4. 检查数据库文件..."
if [ -d "$APP_CONTAINER/Library/Application Support" ]; then
    echo "✅ Application Support 目录存在"
    ls -la "$APP_CONTAINER/Library/Application Support/" | grep -E "store|db|sqlite" || echo "暂无数据库文件"
else
    echo "⚠️  Application Support 目录不存在"
fi
echo ""

echo "5. 检查内存使用..."
xcrun simctl spawn $SIMULATOR_ID launchctl print system | grep com.weiproduct.AICalories || echo "无法获取内存信息"
echo ""

echo "6. 获取应用日志（最后10行）..."
LOG_PATH="$APP_CONTAINER/Documents/Logs"
if [ -d "$LOG_PATH" ]; then
    tail -10 "$LOG_PATH"/*.log 2>/dev/null || echo "暂无日志文件"
else
    echo "暂无日志目录"
fi
echo ""

echo "=== 测试完成 ==="
echo ""
echo "提示："
echo "- 查看截图: open app_screenshot.png"
echo "- 模拟器应该显示AI卡路里的主界面"
echo "- 底部应该有4个标签：今日、记录、历史、我的"