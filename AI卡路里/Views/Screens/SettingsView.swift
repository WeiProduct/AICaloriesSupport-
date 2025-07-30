import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var userProfile: UserProfile?
    @State private var showingProfileEdit = false
    @State private var showingGoalSettings = false
    @State private var showingAbout = false
    @State private var showingReminderSettings = false
    @State private var showingWeightGoalPicker = false
    @State private var showingActivityLevelPicker = false
    @State private var showingMealTimeSettings = false
    @State private var showingDisclaimer = false
    
    var body: some View {
        NavigationStack {
            List {
                profileSection
                goalsSection
                preferencesSection
                aboutSection
            }
            .navigationTitle(LocalizationManager.localized("tab.profile"))
            .onAppear {
                loadUserProfile()
            }
            .sheet(isPresented: $showingProfileEdit) {
                ProfileEditView(profile: $userProfile)
            }
            .sheet(isPresented: $showingGoalSettings) {
                GoalSettingsView(profile: userProfile)
            }
            .sheet(isPresented: $showingReminderSettings) {
                ReminderSettingsView()
            }
            .sheet(isPresented: $showingWeightGoalPicker) {
                WeightGoalPickerView(userProfile: userProfile) {
                    loadUserProfile()
                }
            }
            .sheet(isPresented: $showingActivityLevelPicker) {
                ActivityLevelPickerView(userProfile: userProfile) {
                    loadUserProfile()
                }
            }
            .sheet(isPresented: $showingMealTimeSettings) {
                MealTimeSettingsView()
            }
            .sheet(isPresented: $showingDisclaimer) {
                MedicalDisclaimerView()
            }
        }
    }
    
    private var profileSection: some View {
        Section {
            if let profile = userProfile {
                HStack {
                    VStack(alignment: .leading) {
                        Text(profile.name)
                            .font(.headline)
                        Text("\(profile.age) · \(profile.gender.localizedName)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("\(Int(profile.weight)) \(LocalizationManager.localized("unit.kg"))")
                            .font(.headline)
                        Text("\(Int(profile.height)) \(LocalizationManager.localized("unit.cm"))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    showingProfileEdit = true
                }
            } else {
                Button(action: { showingProfileEdit = true }) {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        VStack(alignment: .leading) {
                            Text(LocalizationManager.localized("settings.setupProfile"))
                                .font(.headline)
                            Text(LocalizationManager.localized("settings.setupProfileDesc"))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                }
            }
        }
    }
    
    private var goalsSection: some View {
        Section(LocalizationManager.localized("settings.goal")) {
            HStack {
                Label(LocalizationManager.localized("today.target"), systemImage: "target")
                Spacer()
                Text("\(Int(userProfile?.targetCalories ?? userProfile?.recommendedCalories ?? Constants.defaultTargetCalories)) \(LocalizationManager.localized("unit.kcal"))")
                    .foregroundColor(.secondary)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                showingGoalSettings = true
            }
            
            HStack {
                Label(LocalizationManager.localized("settings.weightGoal"), systemImage: "scalemass")
                Spacer()
                Text(userProfile?.goal.localizedName ?? LocalizationManager.localized("goal.maintain"))
                    .foregroundColor(.secondary)
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                showingWeightGoalPicker = true
            }
            
            HStack {
                Label(LocalizationManager.localized("settings.activityLevel"), systemImage: "figure.walk")
                Spacer()
                Text(userProfile?.activityLevel.localizedName ?? LocalizationManager.localized("activity.moderate"))
                    .foregroundColor(.secondary)
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                showingActivityLevelPicker = true
            }
        }
    }
    
    private var preferencesSection: some View {
        Section(LocalizationManager.localized("settings.preferences")) {
            
            HStack {
                Label(LocalizationManager.localized("settings.language"), systemImage: "globe")
                Spacer()
                LanguageSwitcher()
            }
            
            Button(action: { showingMealTimeSettings = true }) {
                HStack {
                    Label(LocalizationManager.localized("mealTime.settings"), systemImage: "clock")
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                }
                .foregroundColor(.primary)
            }
            
            Button(action: { showingReminderSettings = true }) {
                HStack {
                    Label(LocalizationManager.localized("settings.reminder"), systemImage: "bell")
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                }
                .foregroundColor(.primary)
            }
            
            HStack {
                Label(LocalizationManager.localized("settings.units"), systemImage: "ruler")
                Spacer()
                Text(LocalizationManager.localized("units.metric"))
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Label(LocalizationManager.localized("settings.dataExport"), systemImage: "square.and.arrow.up")
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var aboutSection: some View {
        Section(LocalizationManager.localized("settings.about")) {
            Button(action: { showingDisclaimer = true }) {
                HStack {
                    Label(LocalizationManager.localized("settings.disclaimer"), systemImage: "exclamationmark.shield")
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                }
                .foregroundColor(.primary)
            }
            
            HStack {
                Label(LocalizationManager.localized("settings.version"), systemImage: "info.circle")
                Spacer()
                Text("1.0.0")
                    .foregroundColor(.secondary)
            }
            
            Button(action: { showingAbout = true }) {
                Label(LocalizationManager.localized("settings.help"), systemImage: "questionmark.circle")
            }
            
            Label(LocalizationManager.localized("settings.feedback"), systemImage: "envelope")
        }
    }
    
    private func loadUserProfile() {
        
        let descriptor = FetchDescriptor<UserProfile>(
            sortBy: [SortDescriptor(\.updatedAt, order: .reverse)]
        )
        
        do {
            userProfile = try modelContext.fetch(descriptor).first
        } catch {
            ErrorHandlingService.shared.handle(error, context: "Loading user profile")
        }
    }
}


struct WeightGoalPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    let userProfile: UserProfile?
    let onSave: () -> Void
    
    @State private var selectedGoal: Goal = .maintain
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(Goal.allCases, id: \.self) { goal in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(goal.localizedName)
                                .font(.headline)
                            Text(goal.description)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        if selectedGoal == goal {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedGoal = goal
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle(LocalizationManager.localized("settings.weightGoal"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(LocalizationManager.localized("action.cancel")) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(LocalizationManager.localized("action.save")) {
                        saveGoal()
                    }
                }
            }
            .onAppear {
                selectedGoal = userProfile?.goal ?? .maintain
            }
        }
    }
    
    private func saveGoal() {
        guard let profile = userProfile else { return }
        
        profile.goal = selectedGoal
        profile.updatedAt = Date()
        
        
        if profile.targetCalories == nil {
            profile.targetCalories = profile.recommendedCalories
        }
        
        do {
            try modelContext.save()
            onSave()
            dismiss()
        } catch {
            ErrorHandlingService.shared.handle(error, context: "Saving weight goal")
        }
    }
}


struct ActivityLevelPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    let userProfile: UserProfile?
    let onSave: () -> Void
    
    @State private var selectedLevel: ActivityLevel = .moderate
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(ActivityLevel.allCases, id: \.self) { level in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(level.localizedName)
                                .font(.headline)
                            Text(level.description)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        if selectedLevel == level {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedLevel = level
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle(LocalizationManager.localized("settings.activityLevel"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(LocalizationManager.localized("action.cancel")) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(LocalizationManager.localized("action.save")) {
                        saveLevel()
                    }
                }
            }
            .onAppear {
                selectedLevel = userProfile?.activityLevel ?? .moderate
            }
        }
    }
    
    private func saveLevel() {
        guard let profile = userProfile else { return }
        
        profile.activityLevel = selectedLevel
        profile.updatedAt = Date()
        
        
        if profile.targetCalories == nil {
            profile.targetCalories = profile.recommendedCalories
        }
        
        do {
            try modelContext.save()
            onSave()
            dismiss()
        } catch {
            ErrorHandlingService.shared.handle(error, context: "Saving activity level")
        }
    }
}