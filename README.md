# AI卡路里 iOS App

## 项目说明
这是一个基于 SwiftUI 和 SwiftData 的 AI 卡路里追踪应用，采用 MVVM 架构模式。

## 功能特性
- 📷 AI 拍照识别食物
- 🍎 食物营养信息记录
- 📊 每日卡路里和营养素追踪
- 📈 历史数据统计和图表
- 💧 饮水记录
- ⚖️ 体重追踪
- 🎯 个性化目标设置

## 解决 Info.plist 冲突

如果遇到 "Multiple commands produce Info.plist" 错误，请按以下步骤操作：

### 方法 1：在 Xcode 中设置
1. 打开 Xcode 项目
2. 选择项目导航器中的 "AI卡路里" 项目（蓝色图标）
3. 选择 "AI卡路里" target
4. 转到 "Info" 标签
5. 添加以下权限：
   - **Privacy - Camera Usage Description**: AI卡路里需要使用相机来拍摄食物照片，以便进行AI识别和记录
   - **Privacy - Photo Library Usage Description**: AI卡路里需要访问相册来选择食物照片进行识别

### 方法 2：清理并重建
```bash
# 清理 DerivedData
rm -rf ~/Library/Developer/Xcode/DerivedData/AI卡路里-*

# 清理项目
xcodebuild clean -project AI卡路里.xcodeproj -scheme AI卡路里

# 重新打开 Xcode
```

## 项目结构
```
AI卡路里/
├── Models/          # 数据模型
├── ViewModels/      # 视图模型
├── Views/           # UI 视图
│   ├── Components/  # 可复用组件
│   └── Screens/     # 主要界面
├── Services/        # 服务层
└── Utils/           # 工具类
```

## 技术栈
- SwiftUI (iOS 17+)
- SwiftData
- Swift Charts
- PhotosUI
- Observation Framework

## 开发环境
- Xcode 15.0+
- iOS 17.0+
- Swift 5.9+

## 快速开始
1. 打开 `AI卡路里.xcodeproj`
2. 选择目标设备或模拟器
3. 按 Cmd+R 运行项目

## 注意事项
- 首次运行会自动创建示例食物数据
- 确保在真机测试相机功能
- 图表功能需要 iOS 16.0+