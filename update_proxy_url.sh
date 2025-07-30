#!/bin/bash

echo "=== 更新代理URL ==="
echo ""
echo "请输入您的Vercel项目URL（例如：https://ai-calorie-proxy.vercel.app）："
read PROXY_URL

if [[ -z "$PROXY_URL" ]]; then
    echo "错误：URL不能为空"
    exit 1
fi

PROXY_URL=${PROXY_URL%/}

FILE="/Users/weifu/Desktop/AI卡路里/AI卡路里/Configuration/APIKeys.swift"

if [[ -f "$FILE" ]]; then
    cp "$FILE" "$FILE.backup"
    
    sed -i '' "s|public static let proxyBaseURL = \".*\"|public static let proxyBaseURL = \"$PROXY_URL\"|" "$FILE"
    
    echo "✓ 已更新代理URL为: $PROXY_URL"
    echo ""
    echo "请在Xcode中重新运行应用以使用新的代理服务器"
else
    echo "错误：找不到APIKeys.swift文件"
    exit 1
fi