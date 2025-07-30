# AI卡路里 API 代理服务器

这是AI卡路里应用的API代理服务器，用于保护API密钥不被暴露在客户端代码中。

## 部署步骤

### 1. 安装 Vercel CLI

```bash
npm install -g vercel
```

### 2. 登录 Vercel

```bash
vercel login
```

### 3. 部署项目

```bash
# 在本目录下执行
vercel

# 按照提示操作，使用默认设置即可
```

### 4. 设置环境变量

```bash
# 添加OpenAI API密钥
vercel env add OPENAI_API_KEY production

# 输入你的OpenAI API密钥，按Enter
```

### 5. 部署到生产环境

```bash
vercel --prod
```

记下输出的URL，例如：`https://ai-calorie-proxy.vercel.app`

### 6. 更新iOS应用配置

在 `AI卡路里/Configuration/APIKeys.swift` 中更新代理URL：

```swift
public static let proxyBaseURL = "https://你的项目名.vercel.app"
```

## 测试

```bash
# 测试API代理
curl -X POST https://你的项目名.vercel.app/api/openai \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-4o",
    "messages": [{"role": "user", "content": "Hello"}],
    "max_tokens": 10
  }'
```

## 安全说明

- API密钥存储在Vercel的环境变量中，不会暴露在代码里
- iOS应用通过代理访问API，无需存储密钥
- Release版本强制使用代理模式，Debug版本可选择直连或代理