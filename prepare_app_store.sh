#!/bin/bash

echo "🍎 AI卡路里 App Store 上架准备检查"
echo "=================================="
echo ""

echo "📱 检查项目配置..."
cd "/Users/weifu/Desktop/AI卡路里"

if [ -f "AI卡路里.xcodeproj/project.pbxproj" ]; then
    echo "✅ Xcode项目文件存在"
else
    echo "❌ 未找到Xcode项目文件"
    exit 1
fi

echo ""
echo "📋 检查关键文件..."

files_to_check=(
    "AI卡路里/AI___App.swift"
    "AI卡路里/Views/Screens/MainTabView.swift"
    "AI卡路里/Services/OpenAIService.swift"
    "AI卡路里/Configuration/APIKeys.swift"
)

for file in "${files_to_check[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file"
    else
        echo "❌ $file 缺失"
    fi
done

echo ""
echo "🌐 检查代理服务器状态..."
if curl -s "https://ai-calorie-proxy.vercel.app/api/health" | grep -q "ok"; then
    echo "✅ 代理服务器运行正常"
else
    echo "⚠️  代理服务器可能有问题，请检查"
fi

echo ""
echo "📝 上架准备清单："
echo ""
echo "必需完成的任务："
echo "□ 配置Bundle ID (在Xcode中设置)"
echo "□ 设置版本号和构建号"
echo "□ 准备应用图标 (1024x1024等各种尺寸)"
echo "□ 配置权限说明 (相机、照片库)"
echo "□ 准备应用截图 (至少5张)"
echo "□ 编写应用描述"
echo "□ 创建App Store Connect记录"
echo "□ Archive构建并上传"
echo ""
echo "🚀 完成这些步骤后，您就可以提交App Store审核了！"
echo ""
echo "📖 详细指南请查看: APP_STORE_SUBMISSION_GUIDE.md"