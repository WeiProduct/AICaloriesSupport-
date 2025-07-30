import SwiftUI

struct LanguageSelectionView: View {
    @AppStorage("selectedLanguage") private var selectedLanguage: String = ""
    @AppStorage("hasSelectedLanguage") private var hasSelectedLanguage: Bool = false
    @State private var isAnimating = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.95, green: 0.98, blue: 0.95),
                        Color(red: 0.90, green: 0.96, blue: 0.90)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    
                    VStack(spacing: 20) {
                        Image(systemName: "camera.metering.center.weighted")
                            .font(.system(size: 80))
                            .foregroundColor(.green)
                            .scaleEffect(isAnimating ? 1.1 : 1.0)
                            .animation(
                                Animation.easeInOut(duration: 2)
                                    .repeatForever(autoreverses: true),
                                value: isAnimating
                            )
                        
                        Text("AI 卡路里")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                    }
                    .padding(.top, geometry.size.height * 0.15)
                    
                    Spacer()
                    
                    
                    HStack(spacing: 0) {
                        
                        Button(action: {
                            selectLanguage("zh")
                        }) {
                            VStack(spacing: 20) {
                                Text("🇨🇳")
                                    .font(.system(size: 60))
                                
                                Text("中文")
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                Text("智能卡路里追踪")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.red.opacity(0.8),
                                        Color.red
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        }
                        .buttonStyle(LanguageButtonStyle())
                        
                        
                        Rectangle()
                            .fill(Color.white.opacity(0.3))
                            .frame(width: 2)
                        
                        
                        Button(action: {
                            selectLanguage("en")
                        }) {
                            VStack(spacing: 20) {
                                Text("🇺🇸")
                                    .font(.system(size: 60))
                                
                                Text("English")
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                Text("Track calories with AI")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.blue.opacity(0.8),
                                        Color.blue
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        }
                        .buttonStyle(LanguageButtonStyle())
                    }
                    .frame(height: geometry.size.height * 0.35)
                    .cornerRadius(0)
                    
                    Spacer()
                    
                    
                    HStack(spacing: 5) {
                        Image(systemName: "gearshape.fill")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.bottom, 50)
                }
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
    
    private func selectLanguage(_ language: String) {
        withAnimation(.easeInOut(duration: 0.3)) {
            selectedLanguage = language
            hasSelectedLanguage = true
            
            
            UserDefaults.standard.set([language], forKey: "AppleLanguages")
            
            
            if language == "zh" {
                
                setupChineseLocalization()
            } else {
                
                setupEnglishLocalization()
            }
        }
    }
    
    private func setupChineseLocalization() {
        
        UserDefaults.standard.set("zh-Hans", forKey: "AppLanguage")
    }
    
    private func setupEnglishLocalization() {
        
        UserDefaults.standard.set("en", forKey: "AppLanguage")
    }
}


struct LanguageButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    LanguageSelectionView()
}