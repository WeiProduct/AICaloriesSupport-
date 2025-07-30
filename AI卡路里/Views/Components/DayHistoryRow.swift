import SwiftUI

struct DayHistoryRow: View {
    let log: DailyLog
    @StateObject private var localizationManager = LocalizationManager.shared
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        let isEnglish = LocalizationManager.shared.selectedLanguage == "en"
        formatter.dateFormat = isEnglish ? "MMM dd, EEEE" : "MM月dd日 EEEE"
        formatter.locale = Locale(identifier: isEnglish ? "en_US" : "zh_CN")
        return formatter
    }
    
    private var calorieStatus: (text: String, color: Color) {
        let difference = log.totalCalories - log.targetCalories
        if abs(difference) <= log.targetCalories * 0.1 {
            return (LocalizationManager.localized("history.status.achieved"), .green)
        } else if difference > 0 {
            return ("\(LocalizationManager.localized("history.status.exceeded")) \(Int(difference))", .red)
        } else {
            return ("\(LocalizationManager.localized("history.status.insufficient")) \(Int(-difference))", .orange)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(dateFormatter.string(from: log.date))
                    .font(.subheadline)
                    .bold()
                
                Spacer()
                
                Text(calorieStatus.text)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(calorieStatus.color.opacity(0.1))
                    .foregroundColor(calorieStatus.color)
                    .cornerRadius(6)
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text("\(Int(log.totalCalories)) \(LocalizationManager.localized("unit.kcal"))")
                        .font(.headline)
                    Text("\(log.meals.count) \(LocalizationManager.localized("history.meals"))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                HStack(spacing: 15) {
                    MacroInfo(label: LocalizationManager.localized("nutrition.protein"), value: log.totalProtein, color: .blue)
                    MacroInfo(label: LocalizationManager.localized("nutrition.carbs"), value: log.totalCarbs, color: .orange)
                    MacroInfo(label: LocalizationManager.localized("nutrition.fat"), value: log.totalFat, color: .purple)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

private struct MacroInfo: View {
    let label: String
    let value: Double
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(Int(value))\(LocalizationManager.localized("unit.gram"))")
                .font(.caption)
                .bold()
                .foregroundColor(color)
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
}