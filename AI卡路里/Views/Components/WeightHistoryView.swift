import SwiftUI
import SwiftData
import Charts

struct WeightHistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \DailyLog.date, order: .reverse) private var dailyLogs: [DailyLog]
    @State private var showingWeightInput = false
    
    var weightLogs: [(date: Date, weight: Double)] {
        dailyLogs.compactMap { log in
            if let weight = log.weight, weight > 0 {
                return (date: log.date, weight: weight)
            }
            return nil
        }
    }
    
    var latestWeight: Double? {
        weightLogs.first?.weight
    }
    
    var goalWeight: Double {
        
        return 65.0
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    currentWeightCard
                    
                    if !weightLogs.isEmpty {
                        weightTrendChart
                        statisticsCards
                        weightHistoryList
                    } else {
                        emptyStateView
                    }
                }
                .padding()
            }
            .navigationTitle(LocalizationManager.localized("weight.history"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingWeightInput = true }) {
                        Image(systemName: "plus.circle.fill")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(LocalizationManager.localized("action.done")) {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingWeightInput) {
                WeightInputView(viewModel: DailySummaryViewModel())
            }
        }
    }
    
    private var currentWeightCard: some View {
        VStack(spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(LocalizationManager.localized("weight.current"))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if let weight = latestWeight {
                        Text("\(String(format: "%.1f", weight)) \(LocalizationManager.localized("unit.kg"))")
                            .font(.title)
                            .bold()
                    } else {
                        Text("-- \(LocalizationManager.localized("unit.kg"))")
                            .font(.title)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 5) {
                    Text(LocalizationManager.localized("weight.goal"))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("\(String(format: "%.1f", goalWeight)) \(LocalizationManager.localized("unit.kg"))")
                        .font(.title2)
                        .foregroundColor(.orange)
                }
            }
            
            if let weight = latestWeight {
                ProgressView(value: min(1.0, (weight - goalWeight + 10) / 20))
                    .progressViewStyle(LinearProgressViewStyle(tint: abs(weight - goalWeight) < 2 ? .green : .orange))
                    .scaleEffect(x: 1, y: 2, anchor: .center)
                
                let difference = weight - goalWeight
                Text(differenceText(difference))
                    .font(.caption)
                    .foregroundColor(abs(difference) < 2 ? .green : .secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    private var weightTrendChart: some View {
        VStack(alignment: .leading) {
            Text(LocalizationManager.localized("weight.trend"))
                .font(.headline)
            
            Chart(weightLogs.prefix(30), id: \.date) { item in
                LineMark(
                    x: .value(LocalizationManager.localized("date"), item.date, unit: .day),
                    y: .value(LocalizationManager.localized("weight.weight"), item.weight)
                )
                .foregroundStyle(.blue)
                .symbol(.circle)
                .symbolSize(50)
                
                RuleMark(y: .value(LocalizationManager.localized("weight.goal"), goalWeight))
                    .foregroundStyle(.orange.opacity(0.5))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
            }
            .frame(height: 200)
            .chartYScale(domain: weightYDomain)
            .chartYAxis {
                AxisMarks(position: .leading)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    private var statisticsCards: some View {
        HStack(spacing: 10) {
            StatCard(
                title: LocalizationManager.localized("weight.weeklyChange"),
                value: weeklyChangeText,
                unit: LocalizationManager.localized("unit.kg"),
                color: weeklyChange > 0 ? .red : .green
            )
            
            StatCard(
                title: LocalizationManager.localized("weight.monthlyChange"),
                value: monthlyChangeText,
                unit: LocalizationManager.localized("unit.kg"),
                color: monthlyChange > 0 ? .red : .green
            )
            
            StatCard(
                title: LocalizationManager.localized("weight.bmi"),
                value: bmiText,
                unit: "",
                color: bmiColor
            )
        }
    }
    
    private var weightHistoryList: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(LocalizationManager.localized("weight.records"))
                .font(.headline)
            
            ForEach(weightLogs.prefix(10), id: \.date) { log in
                HStack {
                    VStack(alignment: .leading) {
                        Text(log.date.formatted(date: .abbreviated, time: .omitted))
                            .font(.subheadline)
                        Text(relativeDateText(log.date))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Text("\(String(format: "%.1f", log.weight)) \(LocalizationManager.localized("unit.kg"))")
                        .font(.subheadline)
                        .bold()
                    
                    if let index = weightLogs.firstIndex(where: { $0.date == log.date }),
                       index < weightLogs.count - 1 {
                        let previousWeight = weightLogs[index + 1].weight
                        let change = log.weight - previousWeight
                        Image(systemName: change > 0 ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                            .foregroundColor(change > 0 ? .red : .green)
                            .font(.caption)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(8)
                .shadow(radius: 1)
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "scalemass")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text(LocalizationManager.localized("weight.noRecords"))
                .font(.headline)
                .foregroundColor(.secondary)
            
            Button(action: { showingWeightInput = true }) {
                Label(LocalizationManager.localized("weight.add"), systemImage: "plus.circle.fill")
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding(.vertical, 50)
    }
    
    
    
    private var weightYDomain: ClosedRange<Double> {
        guard let minWeight = weightLogs.map({ $0.weight }).min(),
              let maxWeight = weightLogs.map({ $0.weight }).max() else {
            return 50...80
        }
        
        let padding = (maxWeight - minWeight) * 0.1
        return (minWeight - padding)...(maxWeight + padding)
    }
    
    private var weeklyChange: Double {
        guard weightLogs.count >= 2 else { return 0 }
        let calendar = Calendar.current
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
        
        if let weekAgoWeight = weightLogs.first(where: { $0.date <= weekAgo })?.weight,
           let currentWeight = latestWeight {
            return currentWeight - weekAgoWeight
        }
        return 0
    }
    
    private var weeklyChangeText: String {
        weeklyChange >= 0 ? "+\(String(format: "%.1f", weeklyChange))" : String(format: "%.1f", weeklyChange)
    }
    
    private var monthlyChange: Double {
        guard weightLogs.count >= 2 else { return 0 }
        let calendar = Calendar.current
        let monthAgo = calendar.date(byAdding: .month, value: -1, to: Date())!
        
        if let monthAgoWeight = weightLogs.first(where: { $0.date <= monthAgo })?.weight,
           let currentWeight = latestWeight {
            return currentWeight - monthAgoWeight
        }
        return 0
    }
    
    private var monthlyChangeText: String {
        monthlyChange >= 0 ? "+\(String(format: "%.1f", monthlyChange))" : String(format: "%.1f", monthlyChange)
    }
    
    private var bmiText: String {
        guard let weight = latestWeight else { return "--" }
        
        let height = 1.75 
        let bmi = weight / (height * height)
        return String(format: "%.1f", bmi)
    }
    
    private var bmiColor: Color {
        guard let weight = latestWeight else { return .gray }
        let height = 1.75 
        let bmi = weight / (height * height)
        
        switch bmi {
        case ..<18.5: return .blue
        case 18.5..<24: return .green
        case 24..<28: return .orange
        default: return .red
        }
    }
    
    
    
    private func differenceText(_ difference: Double) -> String {
        let absValue = abs(difference)
        if absValue < 0.1 {
            return LocalizationManager.localized("weight.atGoal")
        } else if difference > 0 {
            return "\(String(format: "%.1f", absValue)) \(LocalizationManager.localized("unit.kg")) \(LocalizationManager.localized("weight.aboveGoal"))"
        } else {
            return "\(String(format: "%.1f", absValue)) \(LocalizationManager.localized("unit.kg")) \(LocalizationManager.localized("weight.belowGoal"))"
        }
    }
    
    private func relativeDateText(_ date: Date) -> String {
        let calendar = Calendar.current
        let days = calendar.dateComponents([.day], from: date, to: Date()).day ?? 0
        
        if days == 0 {
            return LocalizationManager.localized("date.today")
        } else if days == 1 {
            return LocalizationManager.localized("date.yesterday")
        } else {
            return "\(days) \(LocalizationManager.localized("date.daysAgo"))"
        }
    }
}