# 权限设置说明

## 在 Xcode 中添加相机和相册权限

1. **打开 Xcode 项目**
   - 双击 `AI卡路里.xcodeproj` 文件

2. **选择项目目标**
   - 在左侧导航栏选择 "AI卡路里" 项目（蓝色图标）
   - 在中间面板选择 "AI卡路里" target

3. **添加权限描述**
   - 点击 "Info" 标签
   - 在 "Custom iOS Target Properties" 中点击 "+" 按钮
   - 添加以下两个权限：

   | Key | Value |
   |-----|-------|
   | Privacy - Camera Usage Description | AI卡路里需要使用相机来拍摄食物照片，以便进行AI识别和记录 |
   | Privacy - Photo Library Usage Description | AI卡路里需要访问相册来选择食物照片进行识别 |

4. **保存并运行**
   - 保存项目（Cmd+S）
   - 运行项目（Cmd+R）

## 注意事项

- 这些权限必须在首次使用相机或相册功能前设置
- 权限描述将在用户首次使用相关功能时显示
- 确保描述清晰说明了使用目的