import SwiftUI

struct LanguageSwitcher: View {
    @StateObject private var localizationManager = LocalizationManager.shared
    @State private var showingLanguageSheet = false
    
    var body: some View {
        Button(action: {
            showingLanguageSheet = true
        }) {
            HStack(spacing: 8) {
                Text(currentLanguageFlag)
                    .font(.title2)
                Text(currentLanguageName)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                Image(systemName: "chevron.down")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color(.systemGray6))
            .cornerRadius(8)
        }
        .sheet(isPresented: $showingLanguageSheet) {
            LanguageSelectionSheet()
        }
    }
    
    private var currentLanguageFlag: String {
        localizationManager.selectedLanguage == "zh" ? "🇨🇳" : "🇺🇸"
    }
    
    private var currentLanguageName: String {
        localizationManager.selectedLanguage == "zh" ? "中文" : "English"
    }
}

struct LanguageSelectionSheet: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var localizationManager = LocalizationManager.shared
    
    private let languages = [
        ("zh", "🇨🇳", "中文", "简体中文"),
        ("en", "🇺🇸", "English", "English")
    ]
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("选择语言")
                            .font(.headline)
                        Text("Choose your preferred language for the app interface.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 8)
                }
                
                Section("可用语言 / Available Languages") {
                    ForEach(languages, id: \.0) { language in
                        LanguageRow(
                            code: language.0,
                            flag: language.1,
                            name: language.2,
                            description: language.3,
                            isSelected: localizationManager.selectedLanguage == language.0
                        ) {
                            selectLanguage(language.0)
                        }
                    }
                }
            }
            .navigationTitle("语言设置")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func selectLanguage(_ languageCode: String) {
        withAnimation(.easeInOut(duration: 0.3)) {
            localizationManager.selectedLanguage = languageCode
            
            
            UserDefaults.standard.set(languageCode, forKey: "selectedLanguage")
            UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
            
            
            if languageCode == "zh" {
                UserDefaults.standard.set("zh-Hans", forKey: "AppLanguage")
            } else {
                UserDefaults.standard.set("en", forKey: "AppLanguage")
            }
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                dismiss()
            }
        }
    }
}

struct LanguageRow: View {
    let code: String
    let flag: String
    let name: String
    let description: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Text(flag)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.title2)
                }
            }
            .padding(.vertical, 4)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    LanguageSwitcher()
}