# 最终设置步骤

## ✅ 已完成的步骤

1. **代理服务器已部署** - 部署在 https://ai-calorie-proxy-3g6wmrq61-weis-projects-90c8634a.vercel.app
2. **APIKeys.swift已更新** - 代理URL已更新为实际的Vercel URL

## ⚠️ 必须手动完成的步骤

### 添加OpenAI API密钥

请在终端中执行以下命令：

```bash
cd /Users/weifu/Desktop/AI卡路里/vercel-proxy
vercel env add OPENAI_API_KEY production
```

当提示输入时，粘贴您的OpenAI API密钥（以sk-开头）。

### 重新部署到生产环境

添加密钥后，执行：

```bash
vercel --prod
```

## 测试部署

部署完成后，测试代理服务器：

```bash
curl https://ai-calorie-proxy-3g6wmrq61-weis-projects-90c8634a.vercel.app/api/health
```

应该返回：
```json
{"status":"ok","mode":"proxy"}
```

## 在Xcode中测试

1. 停止当前运行的应用
2. 清理构建（Cmd+Shift+K）
3. 重新运行（Cmd+R）
4. 测试拍照识别功能

## 重要提醒

⚠️ **必须添加API密钥**：代理服务器需要您的OpenAI API密钥才能工作。请确保执行上述步骤添加密钥。

## 故障排除

如果遇到问题：

1. 检查API密钥是否正确添加：
   ```bash
   vercel env ls
   ```

2. 查看部署日志：
   ```bash
   vercel logs
   ```

3. 确保使用的是最新部署：
   ```bash
   vercel ls
   ```