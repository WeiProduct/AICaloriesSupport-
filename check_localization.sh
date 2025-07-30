#!/bin/bash

echo "🌐 AI卡路里 本地化检查"
echo "======================"
echo ""

echo "📋 检查硬编码英文文本..."

swift_files=(
    "AI卡路里/Views/MainTabView.swift"
    "AI卡路里/Views/Screens/LanguageSelectionView.swift"
    "AI卡路里/Views/Screens/CameraFoodRecognitionView.swift"
    "AI卡路里/Views/Screens/DailySummaryView.swift"
    "AI卡路里/Views/Screens/SettingsView.swift"
    "AI卡路里/Utils/LocalizationManager.swift"
)

echo ""
echo "🔍 检查硬编码文本..."

localization_usage=0
total_files=0

for file in "${swift_files[@]}"; do
    if [ -f "$file" ]; then
        total_files=$((total_files + 1))
        
        if grep -q "LocalizationManager.localized" "$file"; then
            echo "✅ $file - 使用本地化"
            localization_usage=$((localization_usage + 1))
        else
            echo "⚠️  $file - 可能包含硬编码文本"
        fi
        
        hardcoded_strings=$(grep -n '"[A-Za-z][^"]*"' "$file" | grep -v "LocalizationManager" | grep -v "systemImage" | grep -v "key" | head -3)
        if [ ! -z "$hardcoded_strings" ]; then
            echo "   可能的硬编码文本:"
            echo "$hardcoded_strings" | sed 's/^/   /'
        fi
    fi
done

echo ""
echo "📊 统计结果:"
echo "   使用本地化的文件: $localization_usage/$total_files"

if [ $localization_usage -eq $total_files ]; then
    echo "✅ 所有关键文件都使用了本地化！"
else
    echo "⚠️  部分文件可能需要检查本地化"
fi

echo ""
echo "🔧 中文本地化键检查..."

if [ -f "AI卡路里/Utils/LocalizationManager.swift" ]; then
    chinese_keys=$(grep -c '"zh":' "AI卡路里/Utils/LocalizationManager.swift")
    english_keys=$(grep -c '"en":' "AI卡路里/Utils/LocalizationManager.swift")
    
    echo "   中文翻译数量: $chinese_keys"
    echo "   英文翻译数量: $english_keys"
    
    if [ $chinese_keys -eq $english_keys ]; then
        echo "✅ 中英文翻译数量匹配"
    else
        echo "⚠️  中英文翻译数量不匹配"
    fi
else
    echo "❌ 找不到LocalizationManager.swift"
fi

echo ""
echo "🎯 语言选择页面检查..."

if [ -f "AI卡路里/Views/Screens/LanguageSelectionView.swift" ]; then
    if grep -q '"AI 卡路里"' "AI卡路里/Views/Screens/LanguageSelectionView.swift"; then
        echo "✅ 语言选择页面使用中文标题"
    else
        echo "⚠️  语言选择页面可能使用英文标题"
    fi
    
    if grep -A 20 "// 中文按钮 (左边)" "AI卡路里/Views/Screens/LanguageSelectionView.swift" | grep -q "智能卡路里追踪"; then
        echo "✅ 中文按钮在左边且文本正确"
    else
        echo "⚠️  中文按钮位置或文本需要检查"
    fi
else
    echo "❌ 找不到LanguageSelectionView.swift"
fi

echo ""
echo "✨ 建议："
echo "1. 确保所有用户可见的文本都使用LocalizationManager.localized()"
echo "2. 在中文模式下测试应用，确保没有英文文本"
echo "3. 检查弹窗、错误消息等也要本地化"
echo "4. 确保日期、数字格式也符合中文习惯"

echo ""
echo "🧪 测试建议："
echo "1. 在语言选择页面选择中文"
echo "2. 检查所有页面和功能"
echo "3. 确认没有任何英文文本出现"
echo "4. 测试拍照识别、设置等功能的中文显示"