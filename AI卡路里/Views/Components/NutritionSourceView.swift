import SwiftUI

struct NutritionSourceView: View {
    @State private var showingFullCitations = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "info.circle")
                    .foregroundColor(.blue)
                    .font(.caption)
                
                Text(LocalizationManager.localized("nutrition.source.info"))
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button(action: { showingFullCitations = true }) {
                    Text(LocalizationManager.localized("citations.viewSource"))
                        .font(.caption2)
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(8)
        }
        .sheet(isPresented: $showingFullCitations) {
            MedicalDisclaimerView()
        }
    }
}

struct CompactNutritionSourceLink: View {
    @State private var showingCitations = false
    
    var body: some View {
        Button(action: { showingCitations = true }) {
            HStack(spacing: 4) {
                Image(systemName: "info.circle")
                    .font(.caption2)
                Text(LocalizationManager.localized("nutrition.dataSource"))
                    .font(.caption2)
            }
            .foregroundColor(.blue)
        }
        .sheet(isPresented: $showingCitations) {
            MedicalDisclaimerView()
        }
    }
}