# 代理模式测试指南

## 部署前准备

### 1. 执行Vercel部署
```bash
cd /Users/weifu/Desktop/AI卡路里/vercel-proxy
vercel login           # 登录Vercel
vercel                 # 初始化项目
vercel env add OPENAI_API_KEY production  # 添加API密钥
vercel --prod         # 部署到生产环境
```

### 2. 更新代理URL
获得Vercel URL后，执行：
```bash
/Users/weifu/Desktop/AI卡路里/update_proxy_url.sh
```
输入您的Vercel项目URL

## 测试步骤

### 测试1：验证代理服务器
```bash
# 替换为您的实际URL
curl https://您的项目名.vercel.app/api/health
```

预期结果：
```json
{"status":"ok","mode":"proxy"}
```

### 测试2：开发模式测试
1. 在Xcode中停止应用
2. 清理构建（Cmd+Shift+K）
3. 重新运行（Cmd+R）
4. 测试功能：
   - 打开应用
   - 进入"拍照记录食物"
   - 选择或拍摄食物照片
   - 确认识别成功

### 测试3：Release模式测试
1. 在Xcode中选择 **Product → Scheme → Edit Scheme**
2. 左侧选择 **Run**
3. 将 **Build Configuration** 改为 **Release**
4. 重新运行应用
5. 验证：
   - 设置中没有"开发者选项"
   - 食物识别功能正常工作
   - 所有API调用通过代理

### 测试4：网络抓包验证
1. 使用Proxyman或Charles等工具
2. 设置iOS模拟器代理
3. 执行食物识别
4. 验证：
   - 只能看到对Vercel的请求
   - 请求中没有API密钥
   - 响应正常返回

## 检查清单

- [ ] Vercel代理服务器已部署
- [ ] APIKeys.swift中的proxyBaseURL已更新
- [ ] 开发模式下食物识别正常
- [ ] Release模式下无开发者选项
- [ ] 网络请求通过代理服务器
- [ ] API密钥未在客户端暴露

## 故障排除

### 问题：Still getting "You didn't provide an API key"
解决：
1. 确认Vercel部署成功
2. 检查环境变量：`vercel env ls`
3. 确认URL正确更新
4. 重启Xcode和模拟器

### 问题：Network request failed
解决：
1. 检查网络连接
2. 验证代理服务器状态
3. 查看Vercel日志：`vercel logs`

### 问题：识别结果为空
解决：
1. 检查API密钥是否有效
2. 确认OpenAI账户有余额
3. 查看Xcode控制台错误信息

## 成功标志

✅ 代理服务器返回健康状态
✅ 食物识别功能正常
✅ 控制台显示使用代理模式
✅ Release模式下无法访问API密钥
✅ 所有测试用例通过