import SwiftUI
import SwiftData

struct GoalSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    let profile: UserProfile?
    
    @State private var targetCalories: Double = Constants.defaultTargetCalories
    @State private var proteinRatio: Double = Constants.defaultProteinRatio * 100
    @State private var carbsRatio: Double = Constants.defaultCarbsRatio * 100
    @State private var fatRatio: Double = Constants.defaultFatRatio * 100
    
    private var totalRatio: Double {
        proteinRatio + carbsRatio + fatRatio
    }
    
    private var isValidRatio: Bool {
        abs(totalRatio - 100) < 0.1
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(LocalizationManager.localized("nutrition.calories")) {
                    HStack {
                        Text(LocalizationManager.localized("today.target"))
                        Slider(value: $targetCalories, in: 1200...4000, step: 50)
                        Text("\(Int(targetCalories))")
                            .frame(width: 60)
                    }
                    
                    if let profile = profile {
                        HStack {
                            Text(LocalizationManager.localized("today.target"))
                            Spacer()
                            Text("\(Int(profile.recommendedCalories)) \(LocalizationManager.localized("unit.kcal"))")
                                .foregroundColor(.green)
                        }
                    }
                }
                
                Section(LocalizationManager.localized("nutrition.title")) {
                    VStack(spacing: 15) {
                        MacroSlider(
                            name: LocalizationManager.localized("nutrition.protein"),
                            value: $proteinRatio,
                            color: .blue,
                            calories: targetCalories
                        )
                        
                        MacroSlider(
                            name: LocalizationManager.localized("nutrition.carbs"),
                            value: $carbsRatio,
                            color: .orange,
                            calories: targetCalories
                        )
                        
                        MacroSlider(
                            name: LocalizationManager.localized("nutrition.fat"),
                            value: $fatRatio,
                            color: .purple,
                            calories: targetCalories
                        )
                    }
                    
                    if !isValidRatio {
                        Text(LocalizationManager.localized("nutrition.title"))
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
                
                Section {
                    Button(LocalizationManager.localized("goal.maintain")) {
                        applyPreset(protein: Constants.defaultProteinRatio * 100, carbs: Constants.defaultCarbsRatio * 100, fat: Constants.defaultFatRatio * 100)
                    }
                    Button(LocalizationManager.localized("goal.lose")) {
                        applyPreset(protein: 35, carbs: 25, fat: 40)
                    }
                    
                    Button(LocalizationManager.localized("goal.gain")) {
                        applyPreset(protein: 40, carbs: 40, fat: 20)
                    }
                }
            }
            .navigationTitle(LocalizationManager.localized("settings.goal"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(LocalizationManager.localized("action.cancel")) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(LocalizationManager.localized("action.save")) {
                        saveGoals()
                    }
                    .disabled(!isValidRatio)
                }
            }
            .onAppear {
                if let profile = profile {
                    targetCalories = profile.targetCalories ?? profile.recommendedCalories
                }
            }
        }
    }
    
    private func applyPreset(protein: Double, carbs: Double, fat: Double) {
        proteinRatio = protein
        carbsRatio = carbs
        fatRatio = fat
    }
    
    private func saveGoals() {
        guard let profile = profile else { return }
        
        profile.targetCalories = targetCalories
        profile.targetProtein = targetCalories * proteinRatio / 100 / 4
        profile.targetCarbs = targetCalories * carbsRatio / 100 / 4
        profile.targetFat = targetCalories * fatRatio / 100 / 9
        profile.updatedAt = Date()
        
        
        updateDailyLogsWithNewTargets()
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            ErrorHandlingService.shared.handle(error, context: "Saving goals")
        }
    }
    
    private func updateDailyLogsWithNewTargets() {
        let descriptor = FetchDescriptor<DailyLog>()
        
        do {
            let dailyLogs = try modelContext.fetch(descriptor)
            for log in dailyLogs {
                log.targetCalories = targetCalories
                log.targetProtein = targetCalories * proteinRatio / 100 / 4
                log.targetCarbs = targetCalories * carbsRatio / 100 / 4
                log.targetFat = targetCalories * fatRatio / 100 / 9
            }
        } catch {
            print("Failed to update daily logs: \(error)")
        }
    }
}

struct MacroSlider: View {
    let name: String
    @Binding var value: Double
    let color: Color
    let calories: Double
    
    private var grams: Int {
        let caloriesFromMacro = calories * value / 100
        switch name {
        case LocalizationManager.localized("nutrition.protein"), LocalizationManager.localized("nutrition.carbs"):
            return Int(caloriesFromMacro / 4)
        case LocalizationManager.localized("nutrition.fat"):
            return Int(caloriesFromMacro / 9)
        default:
            return 0
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(name)
                    .foregroundColor(color)
                Spacer()
                Text("\(Int(value))% · \(grams)g")
                    .foregroundColor(.secondary)
            }
            
            Slider(value: $value, in: 0...100, step: 5)
                .tint(color)
        }
    }
}