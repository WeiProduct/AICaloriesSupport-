import SwiftUI



struct AddWaterReminderView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTime = Date()
    @State private var selectedDays = Set(1...7) 
    let onSave: (NotificationService.WaterReminder) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    DatePicker(LocalizationManager.localized("reminder.time"), 
                              selection: $selectedTime, 
                              displayedComponents: .hourAndMinute)
                }
                
                Section {
                    ForEach(1...7, id: \.self) { day in
                        HStack {
                            Text(weekdayName(day))
                            Spacer()
                            if selectedDays.contains(day) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.green)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if selectedDays.contains(day) {
                                selectedDays.remove(day)
                            } else {
                                selectedDays.insert(day)
                            }
                        }
                    }
                } header: {
                    Text(LocalizationManager.localized("reminder.repeatDays"))
                }
            }
            .navigationTitle(LocalizationManager.localized("reminder.addWater"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(LocalizationManager.localized("action.cancel")) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(LocalizationManager.localized("action.save")) {
                        let reminder = NotificationService.WaterReminder(
                            time: selectedTime,
                            isEnabled: true,
                            repeatDays: selectedDays
                        )
                        onSave(reminder)
                        dismiss()
                    }
                    .disabled(selectedDays.isEmpty)
                }
            }
        }
    }
    
    private func weekdayName(_ day: Int) -> String {
        let weekdayKeys = ["weekday.sunday", "weekday.monday", "weekday.tuesday", "weekday.wednesday", "weekday.thursday", "weekday.friday", "weekday.saturday"]
        return LocalizationManager.localized(weekdayKeys[day - 1])
    }
}



struct AddMealReminderView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedMealType = MealType.breakfast
    @State private var selectedTime = Date()
    let onSave: (NotificationService.MealReminder) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker(LocalizationManager.localized("reminder.mealType"), selection: $selectedMealType) {
                        ForEach(MealType.allCases, id: \.self) { type in
                            Text(type.localizedName).tag(type)
                        }
                    }
                    
                    DatePicker(LocalizationManager.localized("reminder.time"),
                              selection: $selectedTime,
                              displayedComponents: .hourAndMinute)
                }
            }
            .navigationTitle(LocalizationManager.localized("reminder.addMeal"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(LocalizationManager.localized("action.cancel")) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(LocalizationManager.localized("action.save")) {
                        let reminder = NotificationService.MealReminder(
                            mealType: selectedMealType,
                            time: selectedTime,
                            isEnabled: true
                        )
                        onSave(reminder)
                        dismiss()
                    }
                }
            }
            .onAppear {
                
                setDefaultTime()
            }
            .onChange(of: selectedMealType) { _, _ in
                setDefaultTime()
            }
        }
    }
    
    private func setDefaultTime() {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        
        switch selectedMealType {
        case .breakfast:
            components.hour = 8
            components.minute = 0
        case .lunch:
            components.hour = 12
            components.minute = 30
        case .dinner:
            components.hour = 19
            components.minute = 0
        case .snack:
            components.hour = 15
            components.minute = 0
        }
        
        if let date = Calendar.current.date(from: components) {
            selectedTime = date
        }
    }
}



struct EditWeightReminderView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTime: Date
    @State private var selectedFrequency: NotificationService.WeightReminderFrequency
    let onSave: (NotificationService.WeightReminder) -> Void
    
    init(reminder: NotificationService.WeightReminder?, onSave: @escaping (NotificationService.WeightReminder) -> Void) {
        self.onSave = onSave
        
        if let reminder = reminder {
            _selectedTime = State(initialValue: reminder.time)
            _selectedFrequency = State(initialValue: reminder.frequency)
        } else {
            _selectedTime = State(initialValue: Date())
            _selectedFrequency = State(initialValue: .weekly)
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker(LocalizationManager.localized("reminder.frequency"), selection: $selectedFrequency) {
                        ForEach(NotificationService.WeightReminderFrequency.allCases, id: \.self) { frequency in
                            Text(frequency.localizedName).tag(frequency)
                        }
                    }
                    
                    DatePicker(LocalizationManager.localized("reminder.time"),
                              selection: $selectedTime,
                              displayedComponents: .hourAndMinute)
                } footer: {
                    Text(frequencyDescription)
                        .font(.caption)
                }
            }
            .navigationTitle(LocalizationManager.localized("reminder.setWeight"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(LocalizationManager.localized("action.cancel")) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(LocalizationManager.localized("action.save")) {
                        let reminder = NotificationService.WeightReminder(
                            time: selectedTime,
                            frequency: selectedFrequency,
                            isEnabled: true
                        )
                        onSave(reminder)
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var frequencyDescription: String {
        switch selectedFrequency {
        case .daily:
            return LocalizationManager.localized("reminder.weight.daily.description")
        case .weekly:
            return LocalizationManager.localized("reminder.weight.weekly.description")
        case .monthly:
            return LocalizationManager.localized("reminder.weight.monthly.description")
        }
    }
}