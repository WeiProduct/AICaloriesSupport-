import SwiftUI

struct APIModeSwitcher: View {
    @AppStorage("USE_PROXY") private var useProxy = false
    
    var body: some View {
        #if DEBUG
        VStack(spacing: 10) {
            Toggle("使用代理模式", isOn: $useProxy)
                .padding()
            
            HStack {
                Image(systemName: useProxy ? "lock.shield.fill" : "exclamationmark.triangle.fill")
                    .font(.title3)
                    .foregroundColor(useProxy ? .green : .orange)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(useProxy ? "API密钥受保护" : "直连模式（仅开发）")
                        .font(.headline)
                        .foregroundColor(useProxy ? .green : .orange)
                    
                    Text(useProxy ? "通过代理服务器访问API" : "直接使用本地环境变量中的API密钥")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding()
            
            if !useProxy {
                Text("⚠️ 警告：直连模式仅用于开发调试，请勿在生产环境使用")
                    .font(.caption2)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding()
        #else
        EmptyView()  
        #endif
    }
}


struct APIModeSwitcher_Previews: PreviewProvider {
    static var previews: some View {
        APIModeSwitcher()
    }
}