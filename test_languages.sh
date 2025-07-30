#!/bin/bash

echo "=== 语言测试脚本 ==="
echo ""

SIMULATOR_ID="36CE8970-81F7-4F06-96D0-B22F731B36AC"
APP_ID="com.weiproduct.AICalories"

echo "1. 测试英文界面..."
echo "----------------------------------------"
./reset_language.sh > /dev/null 2>&1
sleep 2

xcrun simctl launch $SIMULATOR_ID $APP_ID
sleep 3

xcrun simctl io $SIMULATOR_ID screenshot test_language_selection.png
echo "语言选择页面截图完成"

echo ""
echo "请在模拟器中点击左侧英文按钮..."
echo "等待 5 秒..."
sleep 5

xcrun simctl io $SIMULATOR_ID screenshot test_english_main.png
echo "英文主界面截图完成"

sleep 2
xcrun simctl io $SIMULATOR_ID screenshot test_english_tabs.png
echo "英文标签页截图完成"

echo ""
echo "2. 测试中文界面..."
echo "----------------------------------------"
./reset_language.sh > /dev/null 2>&1
sleep 2

xcrun simctl launch $SIMULATOR_ID $APP_ID
sleep 3

echo "请在模拟器中点击右侧中文按钮..."
echo "等待 5 秒..."
sleep 5

xcrun simctl io $SIMULATOR_ID screenshot test_chinese_main.png
echo "中文主界面截图完成"

echo ""
echo "=== 测试完成 ==="
echo ""
echo "截图文件："
echo "- test_language_selection.png - 语言选择页"
echo "- test_english_main.png - 英文主界面"
echo "- test_chinese_main.png - 中文主界面"
echo ""
echo "注意：需要手动在模拟器中点击选择语言"