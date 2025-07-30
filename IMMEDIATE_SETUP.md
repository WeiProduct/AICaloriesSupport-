# 立即设置步骤

## 1. 添加API密钥（必须手动执行）

请在终端中执行以下命令：

```bash
cd /Users/weifu/Desktop/AI卡路里/vercel-proxy
vercel env add OPENAI_API_KEY production
```

当提示输入时，粘贴您的OpenAI API密钥（以sk-开头）。

## 2. 部署到生产环境

```bash
vercel --prod
```

## 3. 更新代理URL

部署成功后，您会看到一个生产URL。根据初始部署，您的URL应该是：
`https://ai-calorie-proxy.vercel.app`

现在让我们更新APIKeys.swift文件...