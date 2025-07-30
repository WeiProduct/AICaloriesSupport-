import SwiftUI
import Charts
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var selectedPeriod: Period = .week
    @State private var logs: [DailyLog] = []
    @State private var selectedChart: ChartType = .calories
    @State private var showingExport = false
    
    enum Period: String, CaseIterable {
        case week = "week"
        case month = "month"
        case year = "year"
        
        var localizedName: String {
            switch self {
            case .week: return LocalizationManager.localized("history.period.week")
            case .month: return LocalizationManager.localized("history.period.month")
            case .year: return LocalizationManager.localized("history.period.year")
            }
        }
    }
    
    enum ChartType: String, CaseIterable {
        case calories = "calories"
        case nutrients = "nutrients"
        case water = "water"
        
        var localizedName: String {
            switch self {
            case .calories: return LocalizationManager.localized("nutrition.calories")
            case .nutrients: return LocalizationManager.localized("nutrition.title")
            case .water: return LocalizationManager.localized("water.intake")
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    periodSelector
                    calorieChart
                    statisticsCards
                    historyList
                }
                .padding()
            }
            .navigationTitle(LocalizationManager.localized("history.title"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingExport = true }) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
            .onAppear {
                loadHistory()
            }
            .sheet(isPresented: $showingExport) {
                DataExportView()
            }
        }
    }
    
    private var periodSelector: some View {
        VStack(spacing: 10) {
            Picker(LocalizationManager.localized("history.period"), selection: $selectedPeriod) {
                ForEach(Period.allCases, id: \.self) { period in
                    Text(period.localizedName).tag(period)
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: selectedPeriod) { _, _ in
                loadHistory()
            }
            
            Picker(LocalizationManager.localized("history.chartType"), selection: $selectedChart) {
                ForEach(ChartType.allCases, id: \.self) { type in
                    Text(type.localizedName).tag(type)
                }
            }
            .pickerStyle(.segmented)
        }
    }
    
    private var calorieChart: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(chartTitle)
                    .font(.headline)
                Spacer()
                chartLegend
            }
            
            Group {
                switch selectedChart {
                case .calories:
                    caloriesChartContent
                case .nutrients:
                    nutrientsChartContent
                case .water:
                    waterChartContent
                }
            }
            .frame(height: 200)
            .padding(.vertical)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    private var chartTitle: String {
        switch selectedChart {
        case .calories:
            return LocalizationManager.localized("history.caloriesTrend")
        case .nutrients:
            return LocalizationManager.localized("history.nutrientsTrend")
        case .water:
            return LocalizationManager.localized("water.weeklyTrend")
        }
    }
    
    private var chartLegend: some View {
        HStack(spacing: 15) {
            if selectedChart == .calories {
                Label(LocalizationManager.localized("today.consumed"), systemImage: "square.fill")
                    .foregroundColor(.green)
                    .font(.caption)
                Label(LocalizationManager.localized("today.target"), systemImage: "line.horizontal.3")
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
    }
    
    @ViewBuilder
    private var caloriesChartContent: some View {
        Chart(logs) { log in
            BarMark(
                x: .value(LocalizationManager.localized("date"), log.date, unit: .day),
                y: .value(LocalizationManager.localized("nutrition.calories"), log.totalCalories)
            )
            .foregroundStyle(.green)
            .cornerRadius(5)
            
            RuleMark(
                y: .value(LocalizationManager.localized("today.target"), log.targetCalories)
            )
            .foregroundStyle(.red.opacity(0.5))
            .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
    }
    
    @ViewBuilder
    private var nutrientsChartContent: some View {
        Chart(logs) { log in
            BarMark(
                x: .value(LocalizationManager.localized("date"), log.date, unit: .day),
                y: .value(LocalizationManager.localized("nutrition.protein"), log.totalProtein)
            )
            .foregroundStyle(.blue)
            .position(by: .value("Type", "Protein"))
            
            BarMark(
                x: .value(LocalizationManager.localized("date"), log.date, unit: .day),
                y: .value(LocalizationManager.localized("nutrition.carbs"), log.totalCarbs)
            )
            .foregroundStyle(.orange)
            .position(by: .value("Type", "Carbs"))
            
            BarMark(
                x: .value(LocalizationManager.localized("date"), log.date, unit: .day),
                y: .value(LocalizationManager.localized("nutrition.fat"), log.totalFat)
            )
            .foregroundStyle(.purple)
            .position(by: .value("Type", "Fat"))
        }
    }
    
    @ViewBuilder
    private var waterChartContent: some View {
        Chart(logs) { log in
            BarMark(
                x: .value(LocalizationManager.localized("date"), log.date, unit: .day),
                y: .value(LocalizationManager.localized("water.intake"), log.water)
            )
            .foregroundStyle(.blue)
            .cornerRadius(5)
            
            RuleMark(
                y: .value(LocalizationManager.localized("water.target"), 2000)
            )
            .foregroundStyle(.blue.opacity(0.5))
            .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
        }
    }
    
    private var statisticsCards: some View {
        HStack(spacing: 10) {
            StatCard(
                title: LocalizationManager.localized("history.average"),
                value: "\(Int(averageCalories))",
                unit: LocalizationManager.localized("history.perDay"),
                color: .green
            )
            
            StatCard(
                title: LocalizationManager.localized("history.goalDays"),
                value: "\(goalAchievedDays)",
                unit: LocalizationManager.localized("history.days"),
                color: .blue
            )
            
            StatCard(
                title: LocalizationManager.localized("history.streak"),
                value: "\(streakDays)",
                unit: LocalizationManager.localized("history.days"),
                color: .orange
            )
        }
    }
    
    private var historyList: some View {
        VStack(alignment: .leading) {
            Text(LocalizationManager.localized("history.details"))
                .font(.headline)
            
            ForEach(logs) { log in
                DayHistoryRow(log: log)
            }
        }
    }
    
    private var averageCalories: Double {
        guard !logs.isEmpty else { return 0 }
        return logs.reduce(0) { $0 + $1.totalCalories } / Double(logs.count)
    }
    
    private var goalAchievedDays: Int {
        logs.filter { 
            abs($0.totalCalories - $0.targetCalories) <= $0.targetCalories * 0.1 
        }.count
    }
    
    private var streakDays: Int {
        var streak = 0
        let calendar = Calendar.current
        var checkDate = Date()
        
        for _ in 0..<logs.count {
            if logs.contains(where: { calendar.isDate($0.date, inSameDayAs: checkDate) }) {
                streak += 1
                checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate)!
            } else {
                break
            }
        }
        
        return streak
    }
    
    private func loadHistory() {
        
        let calendar = Calendar.current
        let endDate = Date()
        let startDate: Date
        
        switch selectedPeriod {
        case .week:
            startDate = calendar.date(byAdding: .day, value: -7, to: endDate)!
        case .month:
            startDate = calendar.date(byAdding: .month, value: -1, to: endDate)!
        case .year:
            startDate = calendar.date(byAdding: .year, value: -1, to: endDate)!
        }
        
        let predicate = #Predicate<DailyLog> { log in
            log.date >= startDate && log.date <= endDate
        }
        
        let descriptor = FetchDescriptor<DailyLog>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        
        do {
            logs = try modelContext.fetch(descriptor)
        } catch {
            print("Failed to load history: \(error)")
        }
    }
}