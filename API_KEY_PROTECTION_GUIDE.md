# API密钥保护实施指南

## 概述

本项目已实施API密钥保护方案，确保API密钥不会暴露在iOS客户端代码中。

## 架构说明

```
开发模式（Debug）：
iOS App → 可选择直连API或使用代理
         → 直连时使用Xcode环境变量中的API密钥

生产模式（Release）：
iOS App → 代理服务器 → OpenAI API
         （无密钥）    （有密钥）
```

## 已完成的更改

### 1. iOS应用端

- ✅ 创建 `APIKeyManager.swift` - 管理API访问模式
- ✅ 创建 `APIKeys.swift` - 配置代理服务器URL
- ✅ 更新 `OpenAIService.swift` - 移除硬编码的API密钥
- ✅ 添加 `APIModeSwitcher.swift` - 开发时切换访问模式
- ✅ 在设置页面添加开发者选项（仅Debug模式显示）

### 2. 代理服务器

- ✅ 创建 `vercel-proxy/` 目录，包含代理服务器代码
- ✅ 实现OpenAI API代理功能

## 部署步骤

### 步骤1：部署代理服务器到Vercel

1. 进入代理服务器目录：
```bash
cd /Users/weifu/Desktop/AI卡路里/vercel-proxy
```

2. 安装Vercel CLI（如果尚未安装）：
```bash
npm install -g vercel
```

3. 登录Vercel：
```bash
vercel login
```

4. 部署项目：
```bash
vercel
```

5. 设置环境变量：
```bash
vercel env add OPENAI_API_KEY production
# 粘贴你的OpenAI API密钥
```

6. 部署到生产环境：
```bash
vercel --prod
```

### 步骤2：更新iOS应用配置

1. 记下Vercel提供的URL（例如：`https://ai-calorie-proxy.vercel.app`）

2. 更新 `AI卡路里/Configuration/APIKeys.swift`：
```swift
public static let proxyBaseURL = "https://你的vercel-url.vercel.app"
```

### 步骤3：在Xcode中设置开发环境变量

1. 打开Xcode项目
2. 选择项目 → Edit Scheme
3. 选择 Run → Arguments
4. 在 Environment Variables 添加：
   - `OPENAI_API_KEY`: 你的OpenAI密钥

## 使用说明

### 开发模式

1. 在设置页面找到"开发者选项"
2. 可以切换"使用代理模式"开关
3. 关闭时：直接使用环境变量中的API密钥（快速调试）
4. 开启时：通过代理服务器访问（测试生产环境）

### 生产模式

- 自动使用代理模式
- 不显示开发者选项
- API密钥安全存储在服务器端

## 安全验证

### 检查Release版本安全性

1. 在Xcode中切换到Release模式：
   - Product → Scheme → Edit Scheme
   - Run → Build Configuration → Release

2. 运行应用并使用网络抓包工具验证：
   - 只能看到对代理服务器的请求
   - 无法看到API密钥
   - 无法看到对OpenAI的直接请求

## 注意事项

1. **永远不要**在代码中硬编码API密钥
2. **确保** `.gitignore` 包含所有敏感文件
3. **定期更新**代理服务器的依赖项
4. **监控**代理服务器的使用情况和费用

## 故障排除

### 问题：收到401错误
- 检查是否正确设置了Vercel环境变量
- 确认使用的是正确的代理URL

### 问题：开发模式无法直连
- 检查Xcode环境变量是否正确设置
- 确认API密钥格式正确（以`sk-`开头）

### 问题：代理服务器响应慢
- 检查Vercel服务器区域设置
- 考虑升级Vercel计划以获得更好的性能

## 下一步

1. 部署代理服务器
2. 更新iOS应用中的代理URL
3. 测试所有功能正常工作
4. 提交代码前确保移除所有硬编码的密钥