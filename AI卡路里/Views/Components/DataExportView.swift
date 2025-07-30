import SwiftUI
import SwiftData

struct DataExportView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \DailyLog.date, order: .reverse) private var dailyLogs: [DailyLog]
    
    @State private var selectedFormat: ExportFormat = .csv
    @State private var selectedPeriod: ExportPeriod = .week
    @State private var includeWater = true
    @State private var includeMeals = true
    @State private var includeNutrients = true
    @State private var isExporting = false
    @State private var exportResult: String?
    @State private var showingShareSheet = false
    
    enum ExportFormat: String, CaseIterable {
        case csv = "CSV"
        case json = "JSON"
        
        var localizedName: String {
            switch self {
            case .csv: return "CSV"
            case .json: return "JSON"
            }
        }
    }
    
    enum ExportPeriod: String, CaseIterable {
        case week = "week"
        case month = "month"
        case all = "all"
        
        var localizedName: String {
            switch self {
            case .week: return LocalizationManager.localized("export.period.week")
            case .month: return LocalizationManager.localized("export.period.month")
            case .all: return LocalizationManager.localized("export.period.all")
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(LocalizationManager.localized("export.format")) {
                    Picker(LocalizationManager.localized("export.format"), selection: $selectedFormat) {
                        ForEach(ExportFormat.allCases, id: \.self) { format in
                            Text(format.localizedName).tag(format)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section(LocalizationManager.localized("export.period")) {
                    Picker(LocalizationManager.localized("export.period"), selection: $selectedPeriod) {
                        ForEach(ExportPeriod.allCases, id: \.self) { period in
                            Text(period.localizedName).tag(period)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section(LocalizationManager.localized("export.includeData")) {
                    Toggle(LocalizationManager.localized("export.includeWater"), isOn: $includeWater)
                    Toggle(LocalizationManager.localized("export.includeMeals"), isOn: $includeMeals)
                    Toggle(LocalizationManager.localized("export.includeNutrients"), isOn: $includeNutrients)
                }
                
                Section {
                    Button(action: exportData) {
                        if isExporting {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                        } else {
                            Label(LocalizationManager.localized("export.export"), systemImage: "square.and.arrow.up")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .disabled(isExporting)
                }
            }
            .navigationTitle(LocalizationManager.localized("export.title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(LocalizationManager.localized("action.cancel")) {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingShareSheet) {
                if let exportResult = exportResult,
                   let data = exportResult.data(using: .utf8) {
                    ShareSheet(items: [data])
                }
            }
        }
    }
    
    private func exportData() {
        isExporting = true
        
        DispatchQueue.global().async {
            let logs = getLogsForPeriod()
            let exportContent: String
            
            switch selectedFormat {
            case .csv:
                exportContent = exportAsCSV(logs: logs)
            case .json:
                exportContent = exportAsJSON(logs: logs)
            }
            
            DispatchQueue.main.async {
                self.exportResult = exportContent
                self.isExporting = false
                self.showingShareSheet = true
            }
        }
    }
    
    private func getLogsForPeriod() -> [DailyLog] {
        let calendar = Calendar.current
        let endDate = Date()
        let startDate: Date
        
        switch selectedPeriod {
        case .week:
            startDate = calendar.date(byAdding: .day, value: -7, to: endDate)!
        case .month:
            startDate = calendar.date(byAdding: .month, value: -1, to: endDate)!
        case .all:
            return dailyLogs
        }
        
        return dailyLogs.filter { $0.date >= startDate && $0.date <= endDate }
    }
    
    private func exportAsCSV(logs: [DailyLog]) -> String {
        var csv = "Date,Calories,Target Calories"
        
        if includeNutrients {
            csv += ",Protein (g),Carbs (g),Fat (g)"
        }
        
        if includeWater {
            csv += ",Water (ml)"
        }
        
        if includeMeals {
            csv += ",Meals Count"
        }
        
        csv += "\n"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        for log in logs {
            csv += "\(dateFormatter.string(from: log.date)),\(Int(log.totalCalories)),\(Int(log.targetCalories))"
            
            if includeNutrients {
                csv += ",\(Int(log.totalProtein)),\(Int(log.totalCarbs)),\(Int(log.totalFat))"
            }
            
            if includeWater {
                csv += ",\(Int(log.water))"
            }
            
            if includeMeals {
                csv += ",\(log.meals.count)"
            }
            
            csv += "\n"
        }
        
        return csv
    }
    
    private func exportAsJSON(logs: [DailyLog]) -> String {
        var data: [[String: Any]] = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        for log in logs {
            var logData: [String: Any] = [
                "date": dateFormatter.string(from: log.date),
                "calories": Int(log.totalCalories),
                "targetCalories": Int(log.targetCalories)
            ]
            
            if includeNutrients {
                logData["protein"] = Int(log.totalProtein)
                logData["carbs"] = Int(log.totalCarbs)
                logData["fat"] = Int(log.totalFat)
            }
            
            if includeWater {
                logData["water"] = Int(log.water)
            }
            
            if includeMeals {
                logData["mealsCount"] = log.meals.count
                logData["meals"] = log.meals.map { meal in
                    [
                        "food": meal.food?.name ?? "Unknown",
                        "quantity": meal.quantity,
                        "type": meal.mealType.rawValue
                    ]
                }
            }
            
            data.append(logData)
        }
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        }
        
        return "[]"
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}