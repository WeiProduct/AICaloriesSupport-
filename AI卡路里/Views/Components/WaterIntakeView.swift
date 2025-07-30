import SwiftUI

struct WaterIntakeView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: DailySummaryViewModel
    @State private var selectedAmount = Constants.cupVolume
    @State private var showingHistory = false
    @State private var selectedUnit = WaterUnit.ml
    
    enum WaterUnit: String, CaseIterable {
        case ml = "ml"
        case cup = "cup"
        case bottle = "bottle"
        
        var localizedName: String {
            switch self {
            case .ml: return LocalizationManager.localized("water.ml")
            case .cup: return LocalizationManager.localized("water.cup")
            case .bottle: return LocalizationManager.localized("water.bottle")
            }
        }
        
        var multiplier: Double {
            switch self {
            case .ml: return 1.0
            case .cup: return Constants.cupVolume
            case .bottle: return Constants.bottleVolume
            }
        }
    }
    
    let presetAmounts = [200.0, Constants.cupVolume, 300.0, Constants.bottleVolume]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "drop.fill")
                    .font(.system(size: Constants.iconSize))
                    .foregroundColor(.blue)
                    .padding()
                
                Text(LocalizationManager.localized("water.todayIntake"))
                    .font(.headline)
                
                Text("\(Int(viewModel.waterIntake)) \(LocalizationManager.localized("unit.ml"))")
                    .font(.largeTitle)
                    .bold()
                
                
                ProgressView(value: min(viewModel.waterIntake / Constants.defaultWaterTarget, 1.0))
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    .frame(height: 20)
                    .scaleEffect(x: 1, y: 2, anchor: .center)
                    .padding(.horizontal)
                
                Text("\(LocalizationManager.localized("water.target")): \(Int(Constants.defaultWaterTarget)) \(LocalizationManager.localized("unit.ml"))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Divider()
                    .padding(.vertical)
                
                Text(LocalizationManager.localized("water.quickAdd"))
                    .font(.headline)
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 15) {
                    ForEach(presetAmounts, id: \.self) { amount in
                        Button(action: {
                            selectedAmount = amount
                            addWater()
                        }) {
                            VStack(spacing: 4) {
                                Image(systemName: getWaterIcon(for: amount))
                                    .font(.title2)
                                Text("+\(Int(amount))\(LocalizationManager.localized("unit.ml"))")
                                    .font(.caption)
                            }
                                .frame(width: 80, height: 80)
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .cornerRadius(Constants.cornerRadius)
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(LocalizationManager.localized("water.custom"))
                        .font(.headline)
                    
                    
                    Picker(LocalizationManager.localized("water.unit"), selection: $selectedUnit) {
                        ForEach(WaterUnit.allCases, id: \.self) { unit in
                            Text(unit.localizedName).tag(unit)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    HStack {
                        Slider(value: $selectedAmount, in: getMinMax().min...getMinMax().max, step: getStep())
                        Text("\(formatAmount(selectedAmount)) \(selectedUnit.localizedName)")
                            .frame(width: 100)
                    }
                }
                .padding()
                
                HStack(spacing: 15) {
                    Button(action: showWaterHistory) {
                        Label(LocalizationManager.localized("water.history"), systemImage: "clock.arrow.circlepath")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(.primary)
                            .cornerRadius(Constants.cornerRadius)
                    }
                    
                    Button(action: addWater) {
                        Label("\(LocalizationManager.localized("action.add")) \(formatAmount(selectedAmount * selectedUnit.multiplier)) \(LocalizationManager.localized("unit.ml"))", systemImage: "plus.circle.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(Constants.cornerRadius)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .navigationTitle(LocalizationManager.localized("water.recordTitle"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(LocalizationManager.localized("action.done")) {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingHistory) {
                WaterHistoryView()
            }
        }
    }
    
    private func addWater() {
        let actualAmount = selectedAmount * selectedUnit.multiplier
        viewModel.updateWaterIntake(actualAmount)
        HapticFeedback.success()
        
        
        selectedAmount = Constants.cupVolume
        selectedUnit = .ml
    }
    
    private func showWaterHistory() {
        showingHistory = true
    }
    
    private func getWaterIcon(for amount: Double) -> String {
        switch amount {
        case ...200: return "drop"
        case 201...300: return "drop.fill"
        case 301...400: return "drop.triangle"
        default: return "drop.triangle.fill"
        }
    }
    
    private func getMinMax() -> (min: Double, max: Double) {
        switch selectedUnit {
        case .ml: return (50, 1000)
        case .cup: return (0.5, 5)
        case .bottle: return (0.5, 3)
        }
    }
    
    private func getStep() -> Double {
        switch selectedUnit {
        case .ml: return 50
        case .cup: return 0.5
        case .bottle: return 0.5
        }
    }
    
    private func formatAmount(_ amount: Double) -> String {
        switch selectedUnit {
        case .ml: return "\(Int(amount))"
        case .cup, .bottle: return String(format: "%.1f", amount)
        }
    }
}


struct HapticFeedback {
    static func success() {
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }
}