# Vercel代理服务器部署指南

## 快速部署步骤

### 1. 登录Vercel
```bash
cd /Users/weifu/Desktop/AI卡路里/vercel-proxy
vercel login
```

### 2. 初始化项目
```bash
vercel
```

在提示时选择：
- **Set up and deploy?** → `Y`
- **Which scope?** → 选择您的账号
- **Link to existing project?** → `N`
- **What's your project's name?** → `ai-calorie-proxy`（或其他名称）
- **In which directory is your code located?** → `./`
- **Want to modify these settings?** → `N`

### 3. 添加API密钥
```bash
# 添加OpenAI API密钥到生产环境
vercel env add OPENAI_API_KEY production
```
粘贴您的OpenAI API密钥（以sk-开头）

### 4. 部署到生产环境
```bash
vercel --prod
```

### 5. 更新iOS应用配置
部署成功后，您会得到一个URL（例如：`https://ai-calorie-proxy.vercel.app`）

更新文件 `/Users/weifu/Desktop/AI卡路里/AI卡路里/Configuration/APIKeys.swift`：
```swift
public static let proxyBaseURL = "https://您的项目名称.vercel.app"
```

## 验证部署

### 测试代理服务器
```bash
# 替换为您的实际URL
curl https://您的项目名称.vercel.app/api/health
```

应该返回：
```json
{"status":"ok","mode":"proxy"}
```

### 在iOS应用中测试
1. 停止当前运行的应用
2. 在Xcode中重新运行（Cmd+R）
3. 尝试拍照识别功能
4. 检查控制台日志确认使用了代理模式

## 常见问题

### Q: 部署失败？
A: 确保：
- 已正确登录Vercel账号
- 项目名称没有被占用
- 网络连接正常

### Q: API调用失败？
A: 检查：
- 环境变量是否正确设置（`vercel env ls`）
- 代理URL是否正确更新
- OpenAI API密钥是否有效

### Q: 如何查看日志？
A: 使用 `vercel logs` 查看实时日志

## 安全提示
- ✅ API密钥安全存储在Vercel服务器
- ✅ 客户端无法访问密钥
- ✅ 所有API调用都通过代理
- ❌ 不要在代码中硬编码密钥