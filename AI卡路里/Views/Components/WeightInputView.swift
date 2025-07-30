import SwiftUI

struct WeightInputView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: DailySummaryViewModel
    @State private var weight = ""
    @State private var selectedUnit: WeightUnit = .kg
    @FocusState private var isInputFocused: Bool
    
    enum WeightUnit: String, CaseIterable {
        case kg = "kg"
        case lb = "lb"
        
        var localizedName: String {
            switch self {
            case .kg: return LocalizationManager.localized("unit.kg")
            case .lb: return LocalizationManager.localized("unit.lb")
            }
        }
        
        var conversionFactor: Double {
            switch self {
            case .kg: return 1.0
            case .lb: return 0.453592
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "scalemass")
                    .font(.system(size: 60))
                    .foregroundColor(.orange)
                    .padding()
                
                Text(LocalizationManager.localized("weight.record"))
                    .font(.headline)
                
                VStack(spacing: 15) {
                    HStack {
                        TextField(LocalizationManager.localized("weight.weight"), text: $weight)
                            .keyboardType(.decimalPad)
                            .font(.largeTitle)
                            .multilineTextAlignment(.center)
                            .frame(width: 120)
                            .focused($isInputFocused)
                        
                        Text(selectedUnit.localizedName)
                            .font(.title)
                            .foregroundColor(.secondary)
                    }
                    
                    Picker(LocalizationManager.localized("weight.unit"), selection: $selectedUnit) {
                        ForEach(WeightUnit.allCases, id: \.self) { unit in
                            Text(unit.localizedName).tag(unit)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 150)
                }
                .padding()
                
                if viewModel.currentWeight > 0 {
                    let displayWeight = selectedUnit == .kg ? viewModel.currentWeight : viewModel.currentWeight * 2.20462
                    Text("\(LocalizationManager.localized("weight.lastRecord")): \(String(format: "%.1f", displayWeight)) \(selectedUnit.localizedName)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                
                if viewModel.currentWeight > 0 {
                    HStack(spacing: 10) {
                        ForEach([-0.5, -0.2, 0, 0.2, 0.5], id: \.self) { change in
                            Button(action: {
                                let baseWeight = selectedUnit == .kg ? viewModel.currentWeight : viewModel.currentWeight * 2.20462
                                weight = String(format: "%.1f", baseWeight + change)
                            }) {
                                Text(change >= 0 ? "+\(String(format: "%.1f", change))" : String(format: "%.1f", change))
                                    .font(.caption)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(5)
                            }
                        }
                    }
                }
                
                VStack(spacing: 10) {
                    Button(action: saveWeight) {
                        Label(LocalizationManager.localized("action.save"), systemImage: "checkmark.circle.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(weight.isEmpty)
                    
                    Button(action: { showingHistory = true }) {
                        Label(LocalizationManager.localized("weight.viewHistory"), systemImage: "clock.arrow.circlepath")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(.primary)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .navigationTitle(LocalizationManager.localized("weight.recordTitle"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(LocalizationManager.localized("action.cancel")) {
                        dismiss()
                    }
                }
            }
            .onAppear {
                if viewModel.currentWeight > 0 {
                    let displayWeight = selectedUnit == .kg ? viewModel.currentWeight : viewModel.currentWeight * 2.20462
                    weight = String(format: "%.1f", displayWeight)
                }
                isInputFocused = true
            }
            .sheet(isPresented: $showingHistory) {
                WeightHistoryView()
            }
        }
    }
    
    @State private var showingHistory = false
    
    private func saveWeight() {
        if let weightValue = Double(weight) {
            let weightInKg = weightValue * selectedUnit.conversionFactor
            viewModel.updateWeight(weightInKg)
            HapticFeedback.success()
            dismiss()
        }
    }
}