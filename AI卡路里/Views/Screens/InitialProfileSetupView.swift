import SwiftUI
import SwiftData

struct InitialProfileSetupView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("hasCompletedProfile") private var hasCompletedProfile: Bool = false
    
    
    @State private var name: String = ""
    @State private var age: String = ""
    @State private var selectedGender: Gender = .male
    @State private var weight: String = ""
    @State private var height: String = ""
    @State private var goalWeight: String = ""
    @State private var selectedActivityLevel: ActivityLevel = .moderate
    
    
    let selectedGoal: Goal
    
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 25) {
                    
                    VStack(spacing: 10) {
                        Image(systemName: "person.crop.circle.badge.checkmark")
                            .font(.system(size: 60))
                            .foregroundColor(.green)
                        
                        Text(LocalizationManager.localized("profile.setup.title"))
                            .font(.title)
                            .bold()
                        
                        Text(LocalizationManager.localized("profile.setup.subtitle"))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.top, 20)
                    
                    
                    VStack(spacing: 20) {
                        
                        VStack(alignment: .leading, spacing: 15) {
                            SectionHeader(title: LocalizationManager.localized("profile.basicInfo"))
                            
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Label(LocalizationManager.localized("profile.name"), systemImage: "person.fill")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                TextField(LocalizationManager.localized("profile.namePlaceholder"), text: $name)
                                    .textFieldStyle(.roundedBorder)
                            }
                            
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Label(LocalizationManager.localized("profile.age"), systemImage: "calendar")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                TextField(LocalizationManager.localized("profile.agePlaceholder"), text: $age)
                                    .textFieldStyle(.roundedBorder)
                                    .keyboardType(.numberPad)
                            }
                            
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Label(LocalizationManager.localized("profile.gender"), systemImage: "person.2.fill")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Picker("", selection: $selectedGender) {
                                    ForEach(Gender.allCases, id: \.self) { gender in
                                        Text(gender.localizedName).tag(gender)
                                    }
                                }
                                .pickerStyle(.segmented)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(15)
                        
                        
                        VStack(alignment: .leading, spacing: 15) {
                            SectionHeader(title: LocalizationManager.localized("profile.bodyMeasurements"))
                            
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Label(LocalizationManager.localized("profile.currentWeight"), systemImage: "scalemass.fill")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                HStack {
                                    TextField(LocalizationManager.localized("profile.weightPlaceholder"), text: $weight)
                                        .textFieldStyle(.roundedBorder)
                                        .keyboardType(.decimalPad)
                                    
                                    Text(LocalizationManager.localized("unit.kg"))
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Label(LocalizationManager.localized("profile.height"), systemImage: "ruler.fill")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                HStack {
                                    TextField(LocalizationManager.localized("profile.heightPlaceholder"), text: $height)
                                        .textFieldStyle(.roundedBorder)
                                        .keyboardType(.numberPad)
                                    
                                    Text(LocalizationManager.localized("unit.cm"))
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            
                            if selectedGoal != .maintain {
                                VStack(alignment: .leading, spacing: 8) {
                                    Label(LocalizationManager.localized("profile.goalWeight"), systemImage: "target")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    
                                    HStack {
                                        TextField(LocalizationManager.localized("profile.goalWeightPlaceholder"), text: $goalWeight)
                                            .textFieldStyle(.roundedBorder)
                                            .keyboardType(.decimalPad)
                                        
                                        Text(LocalizationManager.localized("unit.kg"))
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(15)
                        
                        
                        VStack(alignment: .leading, spacing: 15) {
                            SectionHeader(title: LocalizationManager.localized("profile.activityLevel"))
                            
                            ForEach(ActivityLevel.allCases, id: \.self) { level in
                                ActivityLevelOption(
                                    level: level,
                                    isSelected: selectedActivityLevel == level,
                                    onTap: { selectedActivityLevel = level }
                                )
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(15)
                    }
                    .padding(.horizontal)
                    
                    
                    Button(action: saveProfile) {
                        Text(LocalizationManager.localized("action.complete"))
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [.green, .green.opacity(0.8)]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(15)
                            .shadow(color: .green.opacity(0.3), radius: 5, x: 0, y: 3)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
            }
            .navigationBarHidden(true)
            .alert(LocalizationManager.localized("error.title"), isPresented: $showingAlert) {
                Button(LocalizationManager.localized("action.ok"), role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func saveProfile() {
        
        guard !name.isEmpty else {
            alertMessage = LocalizationManager.localized("profile.error.nameRequired")
            showingAlert = true
            return
        }
        
        guard let ageValue = Int(age), ageValue > 0, ageValue < 150 else {
            alertMessage = LocalizationManager.localized("profile.error.invalidAge")
            showingAlert = true
            return
        }
        
        guard let weightValue = Double(weight), weightValue > 0, weightValue < 500 else {
            alertMessage = LocalizationManager.localized("profile.error.invalidWeight")
            showingAlert = true
            return
        }
        
        guard let heightValue = Double(height), heightValue > 0, heightValue < 300 else {
            alertMessage = LocalizationManager.localized("profile.error.invalidHeight")
            showingAlert = true
            return
        }
        
        
        var goalWeightValue: Double? = nil
        if selectedGoal != .maintain {
            guard let goalWeight = Double(goalWeight), goalWeight > 0, goalWeight < 500 else {
                alertMessage = LocalizationManager.localized("profile.error.invalidGoalWeight")
                showingAlert = true
                return
            }
            
            
            if selectedGoal == .lose && goalWeight >= weightValue {
                alertMessage = LocalizationManager.localized("profile.error.goalWeightTooHigh")
                showingAlert = true
                return
            } else if selectedGoal == .gain && goalWeight <= weightValue {
                alertMessage = LocalizationManager.localized("profile.error.goalWeightTooLow")
                showingAlert = true
                return
            }
            
            goalWeightValue = goalWeight
        }
        
        
        let profile = UserProfile(
            name: name,
            age: ageValue,
            gender: selectedGender,
            height: heightValue,
            weight: weightValue,
            activityLevel: selectedActivityLevel,
            goal: selectedGoal
        )
        
        
        profile.targetCalories = profile.recommendedCalories
        
        
        if let goalWeightValue = goalWeightValue {
            profile.goalWeight = goalWeightValue
        }
        
        modelContext.insert(profile)
        
        do {
            try modelContext.save()
            hasCompletedProfile = true
        } catch {
            alertMessage = LocalizationManager.localized("profile.error.saveFailed")
            showingAlert = true
        }
    }
}

struct SectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.primary)
    }
}

struct ActivityLevelOption: View {
    let level: ActivityLevel
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(level.localizedName)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Text(level.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
            .padding()
            .background(isSelected ? Color.green.opacity(0.1) : Color.clear)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? Color.green : Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    InitialProfileSetupView(selectedGoal: .lose)
        .modelContainer(for: [UserProfile.self], inMemory: true)
}