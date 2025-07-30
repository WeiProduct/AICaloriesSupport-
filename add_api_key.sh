#!/bin/bash
echo "=== 添加OpenAI API密钥到Vercel ==="
echo ""
echo "请输入您的OpenAI API密钥 (以sk-开头):"
read -s OPENAI_KEY
echo ""

if [[ -z "$OPENAI_KEY" ]]; then
    echo "错误：API密钥不能为空"
    exit 1
fi

echo "正在添加API密钥到生产环境..."
echo "$OPENAI_KEY" | vercel env add OPENAI_API_KEY production

echo ""
echo "✓ API密钥已添加"
echo ""
echo "现在部署到生产环境..."
vercel --prod

echo ""
echo "✓ 部署完成！"
echo ""
echo "您的代理服务器URL是："
echo "https://ai-calorie-proxy.vercel.app"