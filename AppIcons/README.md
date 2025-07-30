# 应用图标安装指南

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
