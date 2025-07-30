#!/bin/bash

echo "修复 Info.plist 权限设置..."

PROJECT_DIR="/Users/weifu/Desktop/AI卡路里"
INFO_PLIST_PATH="${PROJECT_DIR}/AI卡路里/Info.plist"

if [ ! -f "$INFO_PLIST_PATH" ]; then
    echo "创建 Info.plist..."
    cat > "$INFO_PLIST_PATH" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>$(DEVELOPMENT_LANGUAGE)</string>
    <key>CFBundleExecutable</key>
    <string>$(EXECUTABLE_NAME)</string>
    <key>CFBundleIdentifier</key>
    <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>$(PRODUCT_NAME)</string>
    <key>CFBundlePackageType</key>
    <string>$(PRODUCT_BUNDLE_PACKAGE_TYPE)</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSRequiresIPhoneOS</key>
    <true/>
    <key>UIApplicationSceneManifest</key>
    <dict>
        <key>UIApplicationSupportsMultipleScenes</key>
        <false/>
        <key>UISceneConfigurations</key>
        <dict/>
    </dict>
    <key>UIApplicationSupportsIndirectInputEvents</key>
    <true/>
    <key>UILaunchScreen</key>
    <dict/>
    <key>UIRequiredDeviceCapabilities</key>
    <array>
        <string>armv7</string>
    </array>
    <key>UISupportedInterfaceOrientations</key>
    <array>
        <string>UIInterfaceOrientationPortrait</string>
        <string>UIInterfaceOrientationLandscapeLeft</string>
        <string>UIInterfaceOrientationLandscapeRight</string>
    </array>
    <key>UISupportedInterfaceOrientations~ipad</key>
    <array>
        <string>UIInterfaceOrientationPortrait</string>
        <string>UIInterfaceOrientationPortraitUpsideDown</string>
        <string>UIInterfaceOrientationLandscapeLeft</string>
        <string>UIInterfaceOrientationLandscapeRight</string>
    </array>
    <key>NSCameraUsageDescription</key>
    <string>AI卡路里需要使用相机来拍摄食物照片，以便进行AI识别和记录</string>
    <key>NSPhotoLibraryUsageDescription</key>
    <string>AI卡路里需要访问相册来选择食物照片进行识别</string>
</dict>
</plist>
EOF
else
    echo "Info.plist 已存在，添加权限描述..."
    /usr/libexec/PlistBuddy -c "Add :NSCameraUsageDescription string 'AI卡路里需要使用相机来拍摄食物照片，以便进行AI识别和记录'" "$INFO_PLIST_PATH" 2>/dev/null || \
    /usr/libexec/PlistBuddy -c "Set :NSCameraUsageDescription 'AI卡路里需要使用相机来拍摄食物照片，以便进行AI识别和记录'" "$INFO_PLIST_PATH"
    
    /usr/libexec/PlistBuddy -c "Add :NSPhotoLibraryUsageDescription string 'AI卡路里需要访问相册来选择食物照片进行识别'" "$INFO_PLIST_PATH" 2>/dev/null || \
    /usr/libexec/PlistBuddy -c "Set :NSPhotoLibraryUsageDescription 'AI卡路里需要访问相册来选择食物照片进行识别'" "$INFO_PLIST_PATH"
fi

echo "权限设置完成！"

echo "清理构建缓存..."
xcodebuild clean -project "$PROJECT_DIR/AI卡路里.xcodeproj" -scheme "AI卡路里"

echo "修复完成！现在可以重新构建项目了。"