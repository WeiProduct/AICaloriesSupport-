#!/bin/bash

echo "🎨 AI卡路里应用图标生成器"
echo "=========================="
echo ""

if [ -f "icon_1024.png" ]; then
    echo "✅ 发现现有的1024x1024图标文件"
    ICON_FILE="icon_1024.png"
else
    echo "📱 创建临时AI卡路里图标..."
    
    if command -v convert &> /dev/null; then
        convert -size 1024x1024 xc:"#4CAF50" \
                -fill white \
                -gravity center \
                -pointsize 160 \
                -font "Helvetica-Bold" \
                -annotate +0-50 "AI" \
                -pointsize 200 \
                -annotate +0+100 "📸" \
                icon_1024.png
        
        echo "✅ 使用ImageMagick创建了临时图标"
        ICON_FILE="icon_1024.png"
    else
        echo "⚠️  未检测到ImageMagick，将创建纯色图标"
        
        python3 -c "
from PIL import Image, ImageDraw, ImageFont
import os

img = Image.new('RGB', (1024, 1024), color='#4CAF50')
draw = ImageDraw.Draw(img)

try:
    font_large = ImageFont.truetype('/System/Library/Fonts/Helvetica.ttc', 160)
    font_small = ImageFont.truetype('/System/Library/Fonts/Helvetica.ttc', 200)
except:
    font_large = ImageFont.load_default()
    font_small = ImageFont.load_default()

text1 = 'AI'
bbox1 = draw.textbbox((0, 0), text1, font=font_large)
text_width1 = bbox1[2] - bbox1[0]
text_height1 = bbox1[3] - bbox1[1]
x1 = (1024 - text_width1) // 2
y1 = (1024 - text_height1) // 2 - 100
draw.text((x1, y1), text1, fill='white', font=font_large)

text2 = '📷'
bbox2 = draw.textbbox((0, 0), text2, font=font_small)
text_width2 = bbox2[2] - bbox2[0]
x2 = (1024 - text_width2) // 2
y2 = y1 + text_height1 + 50
draw.text((x2, y2), text2, fill='white', font=font_small)

img.save('icon_1024.png', 'PNG')
print('✅ 使用Python创建了图标')
" 2>/dev/null
        
        if [ $? -eq 0 ]; then
            echo "✅ 使用Python PIL创建了图标"
            ICON_FILE="icon_1024.png"
        else
            echo "❌ 无法自动创建图标，请手动创建icon_1024.png文件"
            echo ""
            echo "您可以："
            echo "1. 访问 https://appicon.co 在线生成"
            echo "2. 使用Canva等工具设计"
            echo "3. 创建一个1024x1024的绿色PNG图像并命名为icon_1024.png"
            exit 1
        fi
    fi
fi

mkdir -p AppIcons

echo ""
echo "🔧 生成所需的图标尺寸..."

declare -A icon_sizes=(
    ["120"]="iPhone @2x (120x120)"
    ["152"]="iPad @2x (152x152)" 
    ["180"]="iPhone @3x (180x180)"
    ["76"]="iPad @1x (76x76)"
)

for size in "${!icon_sizes[@]}"; do
    output_file="AppIcons/icon_${size}.png"
    sips -z $size $size "$ICON_FILE" --out "$output_file" > /dev/null 2>&1
    
    if [ $? -eq 0 ]; then
        echo "✅ ${icon_sizes[$size]} → $output_file"
    else
        echo "❌ 生成 ${icon_sizes[$size]} 失败"
    fi
done

cp "$ICON_FILE" "AppIcons/icon_1024.png"
echo "✅ App Store (1024x1024) → AppIcons/icon_1024.png"

echo ""
echo "📱 生成Xcode配置说明..."

cat > AppIcons/README.md << 'EOF'
应用图标安装指南

## 在Xcode中安装图标：

1. 打开Xcode项目
2. 在项目导航器中找到 `Assets.xcassets`
3. 点击 `AppIcon`
4. 将以下文件拖拽到对应位置：

- icon_76.png → iPad App iOS 7-15 @1x (76pt)
- icon_120.png → iPhone App iOS 7-15 @2x (60pt)  
- icon_152.png → iPad App iOS 7-15 @2x (76pt)
- icon_180.png → iPhone App iOS 7-15 @3x (60pt)
- icon_1024.png → App Store iOS 1024pt

## Info.plist配置：

确保您的Info.plist包含：
```xml
<key>CFBundleIconName</key>
<string>AppIcon</string>
```

## 验证：
- Clean Build (Cmd+Shift+K)
- Archive (Product → Archive)
- Validate App
EOF

echo "📋 配置说明已生成: AppIcons/README.md"

echo ""
echo "🎉 图标生成完成！"
echo ""
echo "📝 下一步："
echo "1. 打开Xcode项目"
echo "2. 导航到 Assets.xcassets → AppIcon"
echo "3. 将AppIcons/文件夹中的图标拖拽到对应位置"
echo "4. 确保Info.plist包含CFBundleIconName = 'AppIcon'"
echo "5. Clean Build并重新Archive"
echo ""
echo "📁 生成的文件位于: AppIcons/"
ls -la AppIcons/

echo ""
echo "🔗 如需更专业的图标设计，推荐："
echo "   • Canva: https://canva.com"
echo "   • Icons8: https://icons8.com" 
echo "   • App Icon Generator: https://appicon.co"