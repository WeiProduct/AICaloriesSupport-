import SwiftUI
import SwiftData

struct ProfileEditView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Binding var profile: UserProfile?
    
    @State private var name = ""
    @State private var age = 25
    @State private var gender = Gender.male
    @State private var height = 170.0
    @State private var weight = 70.0
    @State private var activityLevel = ActivityLevel.moderate
    @State private var goal = Goal.maintain
    
    var body: some View {
        NavigationStack {
            Form {
                Section("基本信息") {
                    TextField("姓名", text: $name)
                    
                    Stepper("年龄: \(age)岁", value: $age, in: 1...120)
                    
                    Picker("性别", selection: $gender) {
                        ForEach(Gender.allCases, id: \.self) { gender in
                            Text(gender.rawValue).tag(gender)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("身体数据") {
                    HStack {
                        Text("身高")
                        Slider(value: $height, in: 100...250, step: 1)
                        Text("\(Int(height)) cm")
                            .frame(width: 60)
                    }
                    
                    HStack {
                        Text("体重")
                        Slider(value: $weight, in: 30...200, step: 0.5)
                        Text("\(String(format: "%.1f", weight)) kg")
                            .frame(width: 60)
                    }
                }
                
                Section("活动水平") {
                    Picker("活动水平", selection: $activityLevel) {
                        ForEach(ActivityLevel.allCases, id: \.self) { level in
                            VStack(alignment: .leading) {
                                Text(level.rawValue)
                                Text(level.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .tag(level)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 150)
                }
                
                Section("目标") {
                    Picker("目标", selection: $goal) {
                        ForEach(Goal.allCases, id: \.self) { goal in
                            Text(goal.description).tag(goal)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("计算结果") {
                    HStack {
                        Text("基础代谢率 (BMR)")
                        Spacer()
                        Text("\(Int(calculateBMR())) 千卡/天")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("每日总消耗 (TDEE)")
                        Spacer()
                        Text("\(Int(calculateTDEE())) 千卡/天")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("推荐摄入")
                        Spacer()
                        Text("\(Int(calculateRecommended())) 千卡/天")
                            .bold()
                            .foregroundColor(.green)
                    }
                }
            }
            .navigationTitle(profile == nil ? "创建档案" : "编辑档案")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        saveProfile()
                    }
                    .disabled(name.isEmpty)
                }
            }
            .onAppear {
                if let profile = profile {
                    name = profile.name
                    age = profile.age
                    gender = profile.gender
                    height = profile.height
                    weight = profile.weight
                    activityLevel = profile.activityLevel
                    goal = profile.goal
                }
            }
        }
    }
    
    private func calculateBMR() -> Double {
        if gender == .male {
            return 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * Double(age))
        } else {
            return 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * Double(age))
        }
    }
    
    private func calculateTDEE() -> Double {
        return calculateBMR() * activityLevel.multiplier
    }
    
    private func calculateRecommended() -> Double {
        let tdee = calculateTDEE()
        switch goal {
        case .lose:
            return tdee - 500
        case .maintain:
            return tdee
        case .gain:
            return tdee + 500
        }
    }
    
    private func saveProfile() {
        let recommendedCalories = calculateRecommended()
        
        if let existingProfile = profile {
            existingProfile.name = name
            existingProfile.age = age
            existingProfile.gender = gender
            existingProfile.height = height
            existingProfile.weight = weight
            existingProfile.activityLevel = activityLevel
            existingProfile.goal = goal
            existingProfile.updatedAt = Date()
            
            
            existingProfile.targetCalories = recommendedCalories
            existingProfile.targetProtein = recommendedCalories * Constants.defaultProteinRatio / 4
            existingProfile.targetCarbs = recommendedCalories * Constants.defaultCarbsRatio / 4
            existingProfile.targetFat = recommendedCalories * Constants.defaultFatRatio / 9
        } else {
            let newProfile = UserProfile(
                name: name,
                age: age,
                gender: gender,
                height: height,
                weight: weight,
                activityLevel: activityLevel,
                goal: goal
            )
            
            
            newProfile.targetCalories = recommendedCalories
            newProfile.targetProtein = recommendedCalories * Constants.defaultProteinRatio / 4
            newProfile.targetCarbs = recommendedCalories * Constants.defaultCarbsRatio / 4
            newProfile.targetFat = recommendedCalories * Constants.defaultFatRatio / 9
            
            modelContext.insert(newProfile)
            profile = newProfile
        }
        
        
        updateDailyLogsWithNewTargets(calories: recommendedCalories)
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Failed to save profile: \(error)")
        }
    }
    
    private func updateDailyLogsWithNewTargets(calories: Double) {
        let descriptor = FetchDescriptor<DailyLog>()
        
        do {
            let dailyLogs = try modelContext.fetch(descriptor)
            for log in dailyLogs {
                log.targetCalories = calories
                log.targetProtein = calories * Constants.defaultProteinRatio / 4
                log.targetCarbs = calories * Constants.defaultCarbsRatio / 4
                log.targetFat = calories * Constants.defaultFatRatio / 9
            }
        } catch {
            print("Failed to update daily logs: \(error)")
        }
    }
}