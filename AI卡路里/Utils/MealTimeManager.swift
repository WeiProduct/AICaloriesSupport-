import Foundation
import SwiftUI


struct MealTimeSettings {
    var breakfastStart: Date
    var breakfastEnd: Date
    var lunchStart: Date
    var lunchEnd: Date
    var dinnerStart: Date
    var dinnerEnd: Date
    
    static var `default`: MealTimeSettings {
        let calendar = Calendar.current
        let today = Date()
        
        return MealTimeSettings(
            breakfastStart: calendar.date(bySettingHour: 6, minute: 0, second: 0, of: today) ?? today,
            breakfastEnd: calendar.date(bySettingHour: 10, minute: 0, second: 0, of: today) ?? today,
            lunchStart: calendar.date(bySettingHour: 11, minute: 0, second: 0, of: today) ?? today,
            lunchEnd: calendar.date(bySettingHour: 14, minute: 0, second: 0, of: today) ?? today,
            dinnerStart: calendar.date(bySettingHour: 17, minute: 0, second: 0, of: today) ?? today,
            dinnerEnd: calendar.date(bySettingHour: 20, minute: 0, second: 0, of: today) ?? today
        )
    }
}

class MealTimeManager: ObservableObject {
    static let shared = MealTimeManager()
    
    @Published var settings: MealTimeSettings
    
    private let userDefaults = UserDefaults.standard
    private let calendar = Calendar.current
    
    private init() {
        self.settings = MealTimeManager.loadSettings()
    }
    
    
    func getMealType(for date: Date) -> MealType {
        let currentTime = calendar.dateComponents([.hour, .minute], from: date)
        let currentMinutes = (currentTime.hour ?? 0) * 60 + (currentTime.minute ?? 0)
        
        let breakfastStart = getMinutes(from: settings.breakfastStart)
        let breakfastEnd = getMinutes(from: settings.breakfastEnd)
        let lunchStart = getMinutes(from: settings.lunchStart)
        let lunchEnd = getMinutes(from: settings.lunchEnd)
        let dinnerStart = getMinutes(from: settings.dinnerStart)
        let dinnerEnd = getMinutes(from: settings.dinnerEnd)
        
        
        if isTimeInRange(currentMinutes, start: breakfastStart, end: breakfastEnd) {
            return .breakfast
        } else if isTimeInRange(currentMinutes, start: lunchStart, end: lunchEnd) {
            return .lunch
        } else if isTimeInRange(currentMinutes, start: dinnerStart, end: dinnerEnd) {
            return .dinner
        } else {
            return .snack
        }
    }
    
    private func getMinutes(from date: Date) -> Int {
        let components = calendar.dateComponents([.hour, .minute], from: date)
        return (components.hour ?? 0) * 60 + (components.minute ?? 0)
    }
    
    private func isTimeInRange(_ currentMinutes: Int, start: Int, end: Int) -> Bool {
        if start <= end {
            
            return currentMinutes >= start && currentMinutes <= end
        } else {
            
            return currentMinutes >= start || currentMinutes <= end
        }
    }
    
    
    func getTimeRangeDescription(for mealType: MealType) -> String {
        switch mealType {
        case .breakfast:
            return formatTimeRange(start: settings.breakfastStart, end: settings.breakfastEnd)
        case .lunch:
            return formatTimeRange(start: settings.lunchStart, end: settings.lunchEnd)
        case .dinner:
            return formatTimeRange(start: settings.dinnerStart, end: settings.dinnerEnd)
        case .snack:
            return LocalizationManager.localized("meal.allDay")
        }
    }
    
    private func formatTimeRange(start: Date, end: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: LocalizationManager.shared.selectedLanguage == "zh" ? "zh_CN" : "en_US")
        
        return "\(formatter.string(from: start)) - \(formatter.string(from: end))"
    }
    
    
    func saveSettings() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(settings) {
            userDefaults.set(data, forKey: "MealTimeSettings")
        }
    }
    
    
    private static func loadSettings() -> MealTimeSettings {
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: "MealTimeSettings"),
           let settings = try? decoder.decode(MealTimeSettings.self, from: data) {
            return settings
        }
        return MealTimeSettings.default
    }
    
    
    func resetToDefault() {
        settings = MealTimeSettings.default
        saveSettings()
    }
}


extension MealTimeSettings: Codable {
    enum CodingKeys: String, CodingKey {
        case breakfastStart, breakfastEnd
        case lunchStart, lunchEnd
        case dinnerStart, dinnerEnd
    }
}


extension MealType {
    var dynamicTimeRange: String {
        return MealTimeManager.shared.getTimeRangeDescription(for: self)
    }
}