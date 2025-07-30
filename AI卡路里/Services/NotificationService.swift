import Foundation
import UserNotifications

class NotificationService: ObservableObject {
    static let shared = NotificationService()
    
    @Published var isNotificationEnabled = false
    @Published var waterReminders: [WaterReminder] = []
    @Published var mealReminders: [MealReminder] = []
    @Published var weightReminder: WeightReminder?
    
    private init() {
        loadSettings()
        checkNotificationPermission()
    }
    
    
    
    struct WaterReminder: Identifiable, Codable {
        let id: UUID
        var time: Date
        var isEnabled: Bool
        var repeatDays: Set<Int> 
        
        init(time: Date, isEnabled: Bool, repeatDays: Set<Int>) {
            self.id = UUID()
            self.time = time
            self.isEnabled = isEnabled
            self.repeatDays = repeatDays
        }
        
        var localizedRepeatDays: String {
            if repeatDays.count == 7 {
                return LocalizationManager.localized("reminder.everyday")
            } else if repeatDays.isEmpty {
                return LocalizationManager.localized("reminder.never")
            } else {
                let dayNames = repeatDays.sorted().map { dayNumber in
                    let weekdayKeys = ["", "weekday.sunday", "weekday.monday", "weekday.tuesday", 
                                       "weekday.wednesday", "weekday.thursday", "weekday.friday", "weekday.saturday"]
                    return dayNumber < weekdayKeys.count ? LocalizationManager.localized(weekdayKeys[dayNumber]) : ""
                }
                return dayNames.joined(separator: ", ")
            }
        }
    }
    
    struct MealReminder: Identifiable, Codable {
        let id: UUID
        var mealType: MealType
        var time: Date
        var isEnabled: Bool
        
        init(mealType: MealType, time: Date, isEnabled: Bool) {
            self.id = UUID()
            self.mealType = mealType
            self.time = time
            self.isEnabled = isEnabled
        }
        
        var localizedMealType: String {
            mealType.localizedName
        }
    }
    
    struct WeightReminder: Codable {
        var time: Date
        var frequency: WeightReminderFrequency
        var isEnabled: Bool
    }
    
    enum WeightReminderFrequency: String, CaseIterable, Codable {
        case daily = "daily"
        case weekly = "weekly"
        case monthly = "monthly"
        
        var localizedName: String {
            switch self {
            case .daily: return LocalizationManager.localized("reminder.frequency.daily")
            case .weekly: return LocalizationManager.localized("reminder.frequency.weekly")
            case .monthly: return LocalizationManager.localized("reminder.frequency.monthly")
            }
        }
    }
    
    
    
    func requestNotificationPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                self.isNotificationEnabled = granted
                completion(granted)
            }
        }
    }
    
    private func checkNotificationPermission() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.isNotificationEnabled = settings.authorizationStatus == .authorized
            }
        }
    }
    
    
    
    func addWaterReminder(_ reminder: WaterReminder) {
        waterReminders.append(reminder)
        saveSettings()
        scheduleWaterReminder(reminder)
    }
    
    func updateWaterReminder(_ reminder: WaterReminder) {
        if let index = waterReminders.firstIndex(where: { $0.id == reminder.id }) {
            
            cancelWaterReminder(waterReminders[index])
            
            
            waterReminders[index] = reminder
            saveSettings()
            
            if reminder.isEnabled {
                scheduleWaterReminder(reminder)
            }
        }
    }
    
    func deleteWaterReminder(_ reminder: WaterReminder) {
        waterReminders.removeAll { $0.id == reminder.id }
        saveSettings()
        cancelWaterReminder(reminder)
    }
    
    private func scheduleWaterReminder(_ reminder: WaterReminder) {
        guard reminder.isEnabled else { return }
        
        let content = UNMutableNotificationContent()
        content.title = LocalizationManager.localized("notification.water.title")
        content.body = LocalizationManager.localized("notification.water.body")
        content.sound = .default
        content.categoryIdentifier = "WATER_REMINDER"
        
        for dayNumber in reminder.repeatDays {
            var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: reminder.time)
            dateComponents.weekday = dayNumber
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(
                identifier: "water_\(reminder.id)_\(dayNumber)",
                content: content,
                trigger: trigger
            )
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    ErrorHandlingService.shared.handle(error, context: "Scheduling water reminder")
                }
            }
        }
    }
    
    private func cancelWaterReminder(_ reminder: WaterReminder) {
        let identifiers = reminder.repeatDays.map { "water_\(reminder.id)_\($0)" }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    
    
    func addMealReminder(_ reminder: MealReminder) {
        mealReminders.append(reminder)
        saveSettings()
        scheduleMealReminder(reminder)
    }
    
    func updateMealReminder(_ reminder: MealReminder) {
        if let index = mealReminders.firstIndex(where: { $0.id == reminder.id }) {
            cancelMealReminder(mealReminders[index])
            mealReminders[index] = reminder
            saveSettings()
            
            if reminder.isEnabled {
                scheduleMealReminder(reminder)
            }
        }
    }
    
    func deleteMealReminder(_ reminder: MealReminder) {
        mealReminders.removeAll { $0.id == reminder.id }
        saveSettings()
        cancelMealReminder(reminder)
    }
    
    private func scheduleMealReminder(_ reminder: MealReminder) {
        guard reminder.isEnabled else { return }
        
        let content = UNMutableNotificationContent()
        content.title = LocalizationManager.localized("notification.meal.title")
        content.body = String(format: LocalizationManager.localized("notification.meal.body"), reminder.localizedMealType)
        content.sound = .default
        content.categoryIdentifier = "MEAL_REMINDER"
        
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: reminder.time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: "meal_\(reminder.id)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                ErrorHandlingService.shared.handle(error, context: "Scheduling meal reminder")
            }
        }
    }
    
    private func cancelMealReminder(_ reminder: MealReminder) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["meal_\(reminder.id)"])
    }
    
    
    
    func updateWeightReminder(_ reminder: WeightReminder) {
        
        if weightReminder != nil {
            cancelWeightReminder()
        }
        
        weightReminder = reminder
        saveSettings()
        
        if reminder.isEnabled {
            scheduleWeightReminder(reminder)
        }
    }
    
    func deleteWeightReminder() {
        cancelWeightReminder()
        weightReminder = nil
        saveSettings()
    }
    
    private func scheduleWeightReminder(_ reminder: WeightReminder) {
        guard reminder.isEnabled else { return }
        
        let content = UNMutableNotificationContent()
        content.title = LocalizationManager.localized("notification.weight.title")
        content.body = LocalizationManager.localized("notification.weight.body")
        content.sound = .default
        content.categoryIdentifier = "WEIGHT_REMINDER"
        
        var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: reminder.time)
        
        switch reminder.frequency {
        case .daily:
            
            break
        case .weekly:
            
            dateComponents.weekday = 1
        case .monthly:
            
            dateComponents.day = 1
        }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(
            identifier: "weight_reminder",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                ErrorHandlingService.shared.handle(error, context: "Scheduling weight reminder")
            }
        }
    }
    
    private func cancelWeightReminder() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["weight_reminder"])
    }
    
    
    
    private func saveSettings() {
        let encoder = JSONEncoder()
        
        if let waterData = try? encoder.encode(waterReminders) {
            UserDefaults.standard.set(waterData, forKey: "waterReminders")
        }
        
        if let mealData = try? encoder.encode(mealReminders) {
            UserDefaults.standard.set(mealData, forKey: "mealReminders")
        }
        
        if let weightData = try? encoder.encode(weightReminder) {
            UserDefaults.standard.set(weightData, forKey: "weightReminder")
        }
    }
    
    private func loadSettings() {
        let decoder = JSONDecoder()
        
        if let waterData = UserDefaults.standard.data(forKey: "waterReminders"),
           let reminders = try? decoder.decode([WaterReminder].self, from: waterData) {
            waterReminders = reminders
        }
        
        if let mealData = UserDefaults.standard.data(forKey: "mealReminders"),
           let reminders = try? decoder.decode([MealReminder].self, from: mealData) {
            mealReminders = reminders
        }
        
        if let weightData = UserDefaults.standard.data(forKey: "weightReminder"),
           let reminder = try? decoder.decode(WeightReminder.self, from: weightData) {
            weightReminder = reminder
        }
        
        
        rescheduleAllReminders()
    }
    
    private func rescheduleAllReminders() {
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        
        waterReminders.filter { $0.isEnabled }.forEach { scheduleWaterReminder($0) }
        mealReminders.filter { $0.isEnabled }.forEach { scheduleMealReminder($0) }
        if let weightReminder = weightReminder, weightReminder.isEnabled {
            scheduleWeightReminder(weightReminder)
        }
    }
    
    
    
    func enableDefaultReminders() {
        
        let waterTimes = Constants.defaultWaterReminderHours
        for hour in waterTimes {
            var components = DateComponents()
            components.hour = hour
            components.minute = 0
            
            if let time = Calendar.current.date(from: components) {
                let reminder = WaterReminder(
                    time: time,
                    isEnabled: true,
                    repeatDays: Set(1...7) 
                )
                addWaterReminder(reminder)
            }
        }
        
        
        let mealTimes: [(MealType, hour: Int, minute: Int)] = [
            (.breakfast, Constants.defaultBreakfastHour, 0),
            (.lunch, Constants.defaultLunchHour, 30),
            (.dinner, Constants.defaultDinnerHour, 0)
        ]
        
        for (mealType, hour, minute) in mealTimes {
            var components = DateComponents()
            components.hour = hour
            components.minute = minute
            
            if let time = Calendar.current.date(from: components) {
                let reminder = MealReminder(
                    mealType: mealType,
                    time: time,
                    isEnabled: true
                )
                addMealReminder(reminder)
            }
        }
        
        
        var weightComponents = DateComponents()
        weightComponents.hour = 9
        weightComponents.minute = 0
        
        if let time = Calendar.current.date(from: weightComponents) {
            let reminder = WeightReminder(
                time: time,
                frequency: .weekly,
                isEnabled: true
            )
            updateWeightReminder(reminder)
        }
    }
    
    func disableAllReminders() {
        
        for i in 0..<waterReminders.count {
            waterReminders[i].isEnabled = false
            cancelWaterReminder(waterReminders[i])
        }
        
        
        for i in 0..<mealReminders.count {
            mealReminders[i].isEnabled = false
            cancelMealReminder(mealReminders[i])
        }
        
        
        if var reminder = weightReminder {
            reminder.isEnabled = false
            weightReminder = reminder
            cancelWeightReminder()
        }
        
        saveSettings()
    }
}