import SwiftUI

struct MedicalDisclaimerView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("hasAcceptedDisclaimer") private var hasAcceptedDisclaimer = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    disclaimerSection
                    citationsSection
                    dataSourcesSection
                    limitationsSection
                    
                    if !hasAcceptedDisclaimer {
                        acceptButton
                    }
                }
                .padding()
            }
            .navigationTitle(LocalizationManager.localized("disclaimer.title"))
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                if hasAcceptedDisclaimer {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(LocalizationManager.localized("action.done")) {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
    
    private var disclaimerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(LocalizationManager.localized("disclaimer.important"), systemImage: "exclamationmark.triangle.fill")
                .font(.headline)
                .foregroundColor(.orange)
            
            Text(LocalizationManager.localized("disclaimer.text"))
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(12)
    }
    
    private var citationsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(LocalizationManager.localized("citations.title"))
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 12) {
                CitationRow(
                    title: LocalizationManager.localized("citations.usda.title"),
                    description: LocalizationManager.localized("citations.usda.description"),
                    url: "https://fdc.nal.usda.gov/"
                )
                
                CitationRow(
                    title: LocalizationManager.localized("citations.who.title"),
                    description: LocalizationManager.localized("citations.who.description"),
                    url: "https://www.who.int/news-room/fact-sheets/detail/healthy-diet"
                )
                
                CitationRow(
                    title: LocalizationManager.localized("citations.dri.title"),
                    description: LocalizationManager.localized("citations.dri.description"),
                    url: "https://www.nap.edu/catalog/10490/dietary-reference-intakes-for-energy-carbohydrate-fiber-fat-fatty-acids-cholesterol-protein-and-amino-acids"
                )
                
                CitationRow(
                    title: LocalizationManager.localized("citations.cdc.title"),
                    description: LocalizationManager.localized("citations.cdc.description"),
                    url: "https://www.cdc.gov/nutrition/data-statistics/index.html"
                )
            }
        }
    }
    
    private var dataSourcesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(LocalizationManager.localized("dataSources.title"))
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 8) {
                DataSourceItem(text: LocalizationManager.localized("dataSources.calories"))
                DataSourceItem(text: LocalizationManager.localized("dataSources.macros"))
                DataSourceItem(text: LocalizationManager.localized("dataSources.recommendations"))
                DataSourceItem(text: LocalizationManager.localized("dataSources.bmi"))
                DataSourceItem(text: LocalizationManager.localized("dataSources.water"))
            }
        }
    }
    
    private var limitationsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(LocalizationManager.localized("limitations.title"))
                .font(.headline)
                .foregroundColor(.red)
            
            Text(LocalizationManager.localized("limitations.text"))
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.red.opacity(0.1))
        .cornerRadius(12)
    }
    
    private var acceptButton: some View {
        Button(action: {
            hasAcceptedDisclaimer = true
            dismiss()
        }) {
            Text(LocalizationManager.localized("disclaimer.accept"))
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .cornerRadius(12)
        }
        .padding(.top, 20)
    }
}

struct CitationRow: View {
    let title: String
    let description: String
    let url: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Link(destination: URL(string: url)!) {
                HStack {
                    Text(LocalizationManager.localized("citations.viewSource"))
                        .font(.caption)
                    Image(systemName: "arrow.up.right.square")
                        .font(.caption)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct DataSourceItem: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
                .font(.caption)
            Text(text)
                .font(.body)
        }
    }
}

struct MedicalDisclaimerView_Previews: PreviewProvider {
    static var previews: some View {
        MedicalDisclaimerView()
    }
}