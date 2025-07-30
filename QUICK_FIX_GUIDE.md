# 快速修复指南：API密钥错误

## 问题原因

您遇到的错误是因为：
1. **代理服务器还未部署** - 当前配置的URL `https://my-ai-calorie-proxy.vercel.app` 是示例URL
2. **Xcode环境变量未设置** - 直连模式需要在Xcode中配置API密钥

## 立即解决方案

### 方案1：设置Xcode环境变量（推荐用于开发测试）

1. **在Xcode中设置环境变量**：
   - 打开Xcode项目
   - 点击项目名称旁的scheme（AI卡路里）
   - 选择 "Edit Scheme..."
   - 选择左侧的 "Run"
   - 选择顶部的 "Arguments" 标签
   - 在 "Environment Variables" 部分点击 "+"
   - 添加：
     - Name: `OPENAI_API_KEY`
     - Value: `你的OpenAI API密钥`

2. **切换到直连模式**：
   - 重新运行应用
   - 进入设置 → 开发者选项
   - 关闭"使用代理模式"开关
   - 现在应该可以正常使用了

### 方案2：临时使用硬编码密钥（仅用于测试）

**警告：这仅用于临时测试，请勿提交到代码库！**

1. 修改 `APIKeyManager.swift`：
```swift
public var openAIKey: String? {
    #if DEBUG
    if useProxy {
        return nil
    } else {
        // 临时硬编码，仅用于测试！
        return APIKeys.directOpenAIKey ?? "sk-你的API密钥"
    }
    #else
    return nil
    #endif
}
```

### 方案3：部署代理服务器（生产环境推荐）

1. **部署Vercel代理**：
```bash
cd /Users/weifu/Desktop/AI卡路里/vercel-proxy
npm install -g vercel  # 如果还没安装
vercel login
vercel
```

2. **设置环境变量**：
```bash
vercel env add OPENAI_API_KEY production
# 粘贴你的API密钥
```

3. **部署到生产环境**：
```bash
vercel --prod
```

4. **更新iOS应用配置**：
   - 记下Vercel提供的URL
   - 更新 `APIKeys.swift` 中的 `proxyBaseURL`

## 检查清单

- [ ] 在设置中查看"开发者选项"是否显示
- [ ] 检查"使用代理模式"开关状态
- [ ] 如果使用直连模式，确认Xcode环境变量已设置
- [ ] 如果使用代理模式，确认代理服务器已部署

## 测试步骤

1. 停止当前运行的应用
2. 在Xcode中设置环境变量
3. 重新运行应用（Cmd+R）
4. 进入设置，关闭代理模式
5. 测试拍照识别功能

## 注意事项

- **开发阶段**：建议使用直连模式+环境变量
- **生产发布**：必须部署代理服务器
- **安全提醒**：永远不要将API密钥提交到Git