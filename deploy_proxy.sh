#!/bin/bash

echo "=== AI卡路里代理服务器部署 ==="
echo ""
echo "请先确保您已经："
echo "1. 安装了Vercel CLI (npm install -g vercel)"
echo "2. 有Vercel账号"
echo "3. 有OpenAI API密钥"
echo ""
echo "按Enter继续，或Ctrl+C退出..."
read

cd /Users/weifu/Desktop/AI卡路里/vercel-proxy

echo ""
echo "步骤1: 执行 vercel login 登录您的账号"
echo "步骤2: 执行 vercel 初始化项目"
echo "步骤3: 执行 vercel env add OPENAI_API_KEY production 添加API密钥"
echo "步骤4: 执行 vercel --prod 部署到生产环境"
echo ""
echo "部署完成后，请更新 APIKeys.swift 中的 proxyBaseURL"
echo ""
echo "现在开始执行命令..."
echo ""

echo "请执行以下命令："
echo ""
echo "cd /Users/weifu/Desktop/AI卡路里/vercel-proxy"
echo "vercel login"
echo "vercel"
echo "vercel env add OPENAI_API_KEY production"
echo "vercel --prod"
echo ""
echo "完成后，更新文件："
echo "/Users/weifu/Desktop/AI卡路里/AI卡路里/Configuration/APIKeys.swift"