import SwiftUI

struct ReminderSettingsView: View {
    @StateObject private var notificationService = NotificationService.shared
    @State private var showingPermissionAlert = false
    @State private var showingAddWaterReminder = false
    @State private var showingAddMealReminder = false
    @State private var showingWeightReminder = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                
                Section {
                    HStack {
                        Label(LocalizationManager.localized("reminder.notificationPermission"), systemImage: "bell.badge")
                        Spacer()
                        Toggle("", isOn: $notificationService.isNotificationEnabled)
                            .onChange(of: notificationService.isNotificationEnabled) { _, newValue in
                                if newValue {
                                    notificationService.requestNotificationPermission { granted in
                                        if !granted {
                                            showingPermissionAlert = true
                                        }
                                    }
                                }
                            }
                    }
                } header: {
                    Text(LocalizationManager.localized("reminder.permission"))
                }
                
                
                if notificationService.isNotificationEnabled {
                    Section {
                        Button(action: {
                            notificationService.enableDefaultReminders()
                        }) {
                            Label(LocalizationManager.localized("reminder.enableDefault"), systemImage: "clock.arrow.circlepath")
                        }
                        
                        Button(action: {
                            notificationService.disableAllReminders()
                        }) {
                            Label(LocalizationManager.localized("reminder.disableAll"), systemImage: "bell.slash")
                                .foregroundColor(.red)
                        }
                    } header: {
                        Text(LocalizationManager.localized("reminder.quickActions"))
                    }
                }
                
                
                Section {
                    ForEach(notificationService.waterReminders) { reminder in
                        WaterReminderRow(reminder: reminder) {
                            notificationService.updateWaterReminder($0)
                        } onDelete: {
                            notificationService.deleteWaterReminder($0)
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            notificationService.deleteWaterReminder(notificationService.waterReminders[index])
                        }
                    }
                    
                    Button(action: { showingAddWaterReminder = true }) {
                        Label(LocalizationManager.localized("reminder.addWater"), systemImage: "plus.circle")
                    }
                } header: {
                    Text(LocalizationManager.localized("reminder.water"))
                } footer: {
                    Text(LocalizationManager.localized("reminder.water.description"))
                        .font(.caption)
                }
                
                
                Section {
                    ForEach(notificationService.mealReminders) { reminder in
                        MealReminderRow(reminder: reminder) {
                            notificationService.updateMealReminder($0)
                        } onDelete: {
                            notificationService.deleteMealReminder($0)
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            notificationService.deleteMealReminder(notificationService.mealReminders[index])
                        }
                    }
                    
                    Button(action: { showingAddMealReminder = true }) {
                        Label(LocalizationManager.localized("reminder.addMeal"), systemImage: "plus.circle")
                    }
                } header: {
                    Text(LocalizationManager.localized("reminder.meal"))
                } footer: {
                    Text(LocalizationManager.localized("reminder.meal.description"))
                        .font(.caption)
                }
                
                
                Section {
                    if let weightReminder = notificationService.weightReminder {
                        WeightReminderRow(reminder: weightReminder) {
                            notificationService.updateWeightReminder($0)
                        } onDelete: {
                            notificationService.deleteWeightReminder()
                        }
                    } else {
                        Button(action: { showingWeightReminder = true }) {
                            Label(LocalizationManager.localized("reminder.setWeight"), systemImage: "scalemass")
                        }
                    }
                } header: {
                    Text(LocalizationManager.localized("reminder.weight"))
                } footer: {
                    Text(LocalizationManager.localized("reminder.weight.description"))
                        .font(.caption)
                }
            }
            .navigationTitle(LocalizationManager.localized("settings.reminder"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(LocalizationManager.localized("action.done")) {
                        dismiss()
                    }
                }
            }
            .alert(LocalizationManager.localized("reminder.permissionDenied"), isPresented: $showingPermissionAlert) {
                Button(LocalizationManager.localized("reminder.goToSettings")) {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
                Button(LocalizationManager.localized("action.cancel"), role: .cancel) {}
            } message: {
                Text(LocalizationManager.localized("reminder.permissionDeniedMessage"))
            }
            .sheet(isPresented: $showingAddWaterReminder) {
                AddWaterReminderView { reminder in
                    notificationService.addWaterReminder(reminder)
                }
            }
            .sheet(isPresented: $showingAddMealReminder) {
                AddMealReminderView { reminder in
                    notificationService.addMealReminder(reminder)
                }
            }
            .sheet(isPresented: $showingWeightReminder) {
                EditWeightReminderView(reminder: notificationService.weightReminder) { reminder in
                    notificationService.updateWeightReminder(reminder)
                }
            }
        }
    }
}



struct WaterReminderRow: View {
    let reminder: NotificationService.WaterReminder
    let onUpdate: (NotificationService.WaterReminder) -> Void
    let onDelete: (NotificationService.WaterReminder) -> Void
    @State private var isEnabled: Bool
    
    init(reminder: NotificationService.WaterReminder, onUpdate: @escaping (NotificationService.WaterReminder) -> Void, onDelete: @escaping (NotificationService.WaterReminder) -> Void) {
        self.reminder = reminder
        self.onUpdate = onUpdate
        self.onDelete = onDelete
        self._isEnabled = State(initialValue: reminder.isEnabled)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(reminder.time.formatted(date: .omitted, time: .shortened))
                    .font(.headline)
                Text(reminder.localizedRepeatDays)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $isEnabled)
                .onChange(of: isEnabled) { _, newValue in
                    var updatedReminder = reminder
                    updatedReminder.isEnabled = newValue
                    onUpdate(updatedReminder)
                }
        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                onDelete(reminder)
            } label: {
                Label(LocalizationManager.localized("action.delete"), systemImage: "trash")
            }
        }
    }
}



struct MealReminderRow: View {
    let reminder: NotificationService.MealReminder
    let onUpdate: (NotificationService.MealReminder) -> Void
    let onDelete: (NotificationService.MealReminder) -> Void
    @State private var isEnabled: Bool
    
    init(reminder: NotificationService.MealReminder, onUpdate: @escaping (NotificationService.MealReminder) -> Void, onDelete: @escaping (NotificationService.MealReminder) -> Void) {
        self.reminder = reminder
        self.onUpdate = onUpdate
        self.onDelete = onDelete
        self._isEnabled = State(initialValue: reminder.isEnabled)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(reminder.localizedMealType)
                    .font(.headline)
                Text(reminder.time.formatted(date: .omitted, time: .shortened))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $isEnabled)
                .onChange(of: isEnabled) { _, newValue in
                    var updatedReminder = reminder
                    updatedReminder.isEnabled = newValue
                    onUpdate(updatedReminder)
                }
        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                onDelete(reminder)
            } label: {
                Label(LocalizationManager.localized("action.delete"), systemImage: "trash")
            }
        }
    }
}



struct WeightReminderRow: View {
    let reminder: NotificationService.WeightReminder
    let onUpdate: (NotificationService.WeightReminder) -> Void
    let onDelete: () -> Void
    @State private var isEnabled: Bool
    
    init(reminder: NotificationService.WeightReminder, onUpdate: @escaping (NotificationService.WeightReminder) -> Void, onDelete: @escaping () -> Void) {
        self.reminder = reminder
        self.onUpdate = onUpdate
        self.onDelete = onDelete
        self._isEnabled = State(initialValue: reminder.isEnabled)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(reminder.frequency.localizedName)
                    .font(.headline)
                Text(reminder.time.formatted(date: .omitted, time: .shortened))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $isEnabled)
                .onChange(of: isEnabled) { _, newValue in
                    var updatedReminder = reminder
                    updatedReminder.isEnabled = newValue
                    onUpdate(updatedReminder)
                }
        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label(LocalizationManager.localized("action.delete"), systemImage: "trash")
            }
        }
    }
}