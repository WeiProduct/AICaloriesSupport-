#!/bin/bash

echo "=== AI卡路里 API密钥保护测试 ==="
echo ""

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' 
echo "1. 检查源代码中是否有硬编码的API密钥..."
echo "----------------------------------------"

if grep -r "sk-[a-zA-Z0-9]\{20,\}" AI卡路里 --include="*.swift" 2>/dev/null; then
    echo -e "${RED}❌ 发现硬编码的API密钥！${NC}"
else
    echo -e "${GREEN}✅ 未发现硬编码的API密钥${NC}"
fi

echo ""
echo "2. 检查API管理器实施情况..."
echo "----------------------------------------"

files=(
    "AI卡路里/Services/APIKeyManager.swift"
    "AI卡路里/Configuration/APIKeys.swift"
    "AI卡路里/Views/Components/APIModeSwitcher.swift"
    "vercel-proxy/api/openai.js"
    "vercel-proxy/vercel.json"
)

all_exist=true
for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✅ $file 存在${NC}"
    else
        echo -e "${RED}❌ $file 不存在${NC}"
        all_exist=false
    fi
done

echo ""
echo "3. 检查OpenAIService更新情况..."
echo "----------------------------------------"

if grep -q "apiManager" AI卡路里/Services/OpenAIService.swift 2>/dev/null; then
    echo -e "${GREEN}✅ OpenAIService 已更新使用APIKeyManager${NC}"
else
    echo -e "${RED}❌ OpenAIService 未更新${NC}"
fi

echo ""
echo "4. 项目结构概览..."
echo "----------------------------------------"
echo "iOS应用端："
tree -L 2 AI卡路里/Services AI卡路里/Configuration 2>/dev/null || ls -la AI卡路里/Services AI卡路里/Configuration

echo ""
echo "代理服务器："
tree -L 2 vercel-proxy 2>/dev/null || ls -la vercel-proxy

echo ""
echo "=== 下一步操作 ==="
echo "----------------------------------------"
echo "1. 部署代理服务器："
echo "   cd vercel-proxy"
echo "   vercel"
echo ""
echo "2. 设置环境变量："
echo "   vercel env add OPENAI_API_KEY production"
echo ""
echo "3. 更新iOS应用中的代理URL"
echo "4. 在Xcode中设置开发环境变量"
echo ""
echo -e "${YELLOW}提示：查看 API_KEY_PROTECTION_GUIDE.md 获取详细说明${NC}"