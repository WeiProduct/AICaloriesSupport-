#!/bin/bash

echo "=== AI卡路里 Vercel代理部署脚本 ==="
echo ""
echo "这个脚本将帮助您部署代理服务器到Vercel"
echo ""

echo "1. 检查Vercel登录状态..."
if ! vercel whoami > /dev/null 2>&1; then
    echo "您需要先登录Vercel账号"
    echo "执行: vercel login"
    exit 1
fi

echo "✓ 已登录Vercel"
echo ""

echo "2. 初始化Vercel项目..."
echo "请按照提示完成以下步骤："
echo ""
echo ""
echo ""
echo ""
echo ""
echo ""
echo ""

vercel

echo ""
echo "3. 设置环境变量..."
echo "请输入您的OpenAI API密钥 (sk-...):"
read -s OPENAI_KEY
echo ""

echo "正在添加环境变量..."
echo "$OPENAI_KEY" | vercel env add OPENAI_API_KEY production

echo ""
echo "4. 部署到生产环境..."
vercel --prod

echo ""
echo "=== 部署完成！==="
echo ""
echo "请记录您的生产URL（类似 https://ai-calorie-proxy.vercel.app）"
echo "然后更新 AI卡路里/AI卡路里/Configuration/APIKeys.swift 中的 proxyBaseURL"
echo ""
echo "完成后，您的应用将通过安全的代理服务器访问OpenAI API！"