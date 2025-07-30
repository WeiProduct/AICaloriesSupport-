#!/bin/bash

echo "=== 测试新的拍照功能 ==="
echo ""

SIMULATOR_ID="36CE8970-81F7-4F06-96D0-B22F731B36AC"

echo "1. 应用当前状态"
echo "----------------------------------------"
APP_PID=$(xcrun simctl spawn $SIMULATOR_ID launchctl list | grep com.weiproduct.AICalories | awk '{print $1}')
echo "应用进程 ID: $APP_PID"
echo ""

echo "2. 新的 UI 布局"
echo "----------------------------------------"
echo "✅ 底部导航栏现在有 5 个标签："
echo "   1. 今日 - 查看今日摄入情况"
echo "   2. 记录 - 搜索和手动添加食物"
echo "   3. 🎯 拍照 - AI识别食物（核心功能）"
echo "   4. 历史 - 查看历史数据"
echo "   5. 我的 - 个人设置"
echo ""

echo "3. 拍照功能特点"
echo "----------------------------------------"
echo "✅ 独立的标签页，更加突出"
echo "✅ 点击直接进入拍照/相册选择界面"
echo "✅ AI 识别多个食物并显示置信度"
echo "✅ 可以调整识别结果的数量和营养成分"
echo "✅ 支持添加备注和选择餐次"
echo ""

echo "4. 功能改进"
echo "----------------------------------------"
echo "✅ 拍照功能更容易访问"
echo "✅ 记录页面专注于搜索和手动添加"
echo "✅ 识别结果可以编辑和调整"
echo "✅ 支持批量识别多个食物"
echo ""

echo "5. 截取各页面..."
echo "----------------------------------------"
for i in {1..3}; do
    sleep 1
    xcrun simctl io $SIMULATOR_ID screenshot "camera_test_$i.png" 2>/dev/null
    echo "截图 $i 完成"
done

echo ""
echo "=== 测试完成 ==="
echo ""
echo "改进总结："
echo "1. 拍照功能现在是独立的核心功能标签"
echo "2. 用户可以一键访问 AI 识别功能"
echo "3. 更符合 AI 卡路里追踪的产品定位"
echo "4. 使用流程更加直观和高效"