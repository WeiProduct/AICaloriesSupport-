import SwiftUI
import SwiftData
import Charts

struct WaterHistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \DailyLog.date, order: .reverse) private var dailyLogs: [DailyLog]
    
    var last7DaysLogs: [DailyLog] {
        let calendar = Calendar.current
        let sevenDaysAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
        return dailyLogs.filter { $0.date >= sevenDaysAgo }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    summaryCard
                    
                    
                    weeklyChart
                    
                    
                    dailyList
                }
                .padding()
            }
            .navigationTitle(LocalizationManager.localized("water.history"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(LocalizationManager.localized("action.done")) {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var summaryCard: some View {
        VStack(spacing: 10) {
            HStack {
                VStack(alignment: .leading) {
                    Text(LocalizationManager.localized("water.weeklyAverage"))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(Int(weeklyAverage)) \(LocalizationManager.localized("unit.ml"))")
                        .font(.title2)
                        .bold()
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(LocalizationManager.localized("water.goalAchievement"))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(goalAchievementRate)%")
                        .font(.title2)
                        .bold()
                        .foregroundColor(goalAchievementRate >= 80 ? .green : .orange)
                }
            }
            
            ProgressView(value: Double(goalAchievementRate) / 100)
                .progressViewStyle(LinearProgressViewStyle(tint: goalAchievementRate >= 80 ? .green : .orange))
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    private var weeklyChart: some View {
        VStack(alignment: .leading) {
            Text(LocalizationManager.localized("water.weeklyTrend"))
                .font(.headline)
            
            Chart(last7DaysLogs) { log in
                BarMark(
                    x: .value(LocalizationManager.localized("date"), log.date, unit: .day),
                    y: .value(LocalizationManager.localized("water.intake"), log.water)
                )
                .foregroundStyle(.blue)
                
                
                RuleMark(y: .value(LocalizationManager.localized("water.target"), Constants.defaultWaterTarget))
                    .foregroundStyle(.gray.opacity(0.5))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
            }
            .frame(height: 200)
            .chartYAxisLabel(LocalizationManager.localized("unit.ml"))
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    private var dailyList: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(LocalizationManager.localized("water.dailyRecords"))
                .font(.headline)
            
            ForEach(last7DaysLogs) { log in
                HStack {
                    VStack(alignment: .leading) {
                        Text(log.date.formatted(date: .abbreviated, time: .omitted))
                            .font(.subheadline)
                        Text(getDayOfWeek(log.date))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 5) {
                        Image(systemName: getWaterIcon(for: log.water))
                            .foregroundColor(.blue)
                        Text("\(Int(log.water)) \(LocalizationManager.localized("unit.ml"))")
                            .font(.subheadline)
                            .bold()
                    }
                    
                    Image(systemName: log.water >= Constants.defaultWaterTarget ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(log.water >= Constants.defaultWaterTarget ? .green : .gray)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(8)
                .shadow(radius: 1)
            }
        }
    }
    
    private var weeklyAverage: Double {
        guard !last7DaysLogs.isEmpty else { return 0 }
        let total = last7DaysLogs.reduce(0) { $0 + $1.water }
        return total / Double(last7DaysLogs.count)
    }
    
    private var goalAchievementRate: Int {
        guard !last7DaysLogs.isEmpty else { return 0 }
        let achievedDays = last7DaysLogs.filter { $0.water >= Constants.defaultWaterTarget }.count
        return Int((Double(achievedDays) / Double(last7DaysLogs.count)) * 100)
    }
    
    private func getDayOfWeek(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = LocalizationManager.shared.selectedLanguage == "en" ? "EEEE" : "EEEE"
        formatter.locale = Locale(identifier: LocalizationManager.shared.selectedLanguage == "en" ? "en_US" : "zh_CN")
        return formatter.string(from: date)
    }
    
    private func getWaterIcon(for amount: Double) -> String {
        switch amount {
        case 0..<Constants.bottleVolume: return "drop"
        case Constants.bottleVolume..<1000: return "drop.fill"
        case 1000..<1500: return "drop.triangle"
        case 1500..<Constants.defaultWaterTarget: return "drop.triangle.fill"
        default: return "drop.circle.fill"
        }
    }
}