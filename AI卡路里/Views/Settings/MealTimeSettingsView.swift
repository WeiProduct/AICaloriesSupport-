import SwiftUI

struct MealTimeSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var mealTimeManager = MealTimeManager.shared
    @State private var showingResetConfirmation = false
    
    var body: some View {
        NavigationStack {
            List {
                
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(LocalizationManager.localized("mealTime.settings"))
                            .font(.headline)
                        Text(LocalizationManager.localized("mealTime.description"))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 8)
                }
                
                
                Section("早餐时间 🌅") {
                    HStack {
                        Text(LocalizationManager.localized("mealTime.startTime"))
                        Spacer()
                        DatePicker("", selection: $mealTimeManager.settings.breakfastStart, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                    
                    HStack {
                        Text(LocalizationManager.localized("mealTime.endTime"))
                        Spacer()
                        DatePicker("", selection: $mealTimeManager.settings.breakfastEnd, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                }
                
                
                Section("午餐时间 ☀️") {
                    HStack {
                        Text("开始时间")
                        Spacer()
                        DatePicker("", selection: $mealTimeManager.settings.lunchStart, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                    
                    HStack {
                        Text("结束时间")
                        Spacer()
                        DatePicker("", selection: $mealTimeManager.settings.lunchEnd, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                }
                
                
                Section("晚餐时间 🌙") {
                    HStack {
                        Text("开始时间")
                        Spacer()
                        DatePicker("", selection: $mealTimeManager.settings.dinnerStart, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                    
                    HStack {
                        Text("结束时间")
                        Spacer()
                        DatePicker("", selection: $mealTimeManager.settings.dinnerEnd, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                }
                
                
                Section("时间段预览") {
                    VStack(spacing: 12) {
                        TimeRangePreview(mealType: .breakfast, manager: mealTimeManager)
                        TimeRangePreview(mealType: .lunch, manager: mealTimeManager)
                        TimeRangePreview(mealType: .dinner, manager: mealTimeManager)
                        
                        HStack {
                            Text("零食 🍿")
                                .font(.subheadline)
                            Spacer()
                            Text("其他时间")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                
                Section {
                    Button("重置为默认时间") {
                        showingResetConfirmation = true
                    }
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle("餐食时间设置")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        mealTimeManager.saveSettings()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
            .alert("重置时间设置", isPresented: $showingResetConfirmation) {
                Button("取消", role: .cancel) { }
                Button("重置", role: .destructive) {
                    mealTimeManager.resetToDefault()
                }
            } message: {
                Text("确定要重置为默认的餐食时间吗？")
            }
        }
    }
}

struct TimeRangePreview: View {
    let mealType: MealType
    let manager: MealTimeManager
    
    var body: some View {
        HStack {
            Text("\(mealType.localizedName) \(mealType.icon)")
                .font(.subheadline)
            Spacer()
            Text(manager.getTimeRangeDescription(for: mealType))
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    MealTimeSettingsView()
}