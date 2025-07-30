import SwiftUI
import SwiftData

@main
struct AICalorieApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Food.self,
            Meal.self,
            DailyLog.self,
            UserProfile.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            
            
            print("Failed to create ModelContainer with persistent storage: \(error)")
            print("Attempting to create fresh container...")
            
            
            let freshConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false, allowsSave: true)
            
            do {
                
                let url = freshConfiguration.url
                try? FileManager.default.removeItem(at: url)
                
                return try ModelContainer(for: schema, configurations: [freshConfiguration])
            } catch {
                
                print("Failed to create fresh container: \(error)")
                let memoryConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
                return try! ModelContainer(for: schema, configurations: [memoryConfiguration])
            }
        }
    }()

    @AppStorage("hasSelectedLanguage") private var hasSelectedLanguage: Bool = false
    @AppStorage("hasSelectedGoal") private var hasSelectedGoal: Bool = false
    @AppStorage("hasCompletedProfile") private var hasCompletedProfile: Bool = false
    @AppStorage("hasAcceptedDisclaimer") private var hasAcceptedDisclaimer: Bool = false
    @AppStorage("selectedGoal") private var storedGoal: String = Goal.maintain.rawValue
    
    var body: some Scene {
        WindowGroup {
            if !hasSelectedLanguage {
                LanguageSelectionView()
                    .withErrorHandling()
            } else if !hasAcceptedDisclaimer {
                MedicalDisclaimerView()
                    .withErrorHandling()
            } else if !hasSelectedGoal {
                GoalSelectionView()
                    .withErrorHandling()
            } else if !hasCompletedProfile {
                if let goal = Goal(rawValue: storedGoal) {
                    InitialProfileSetupView(selectedGoal: goal)
                        .withErrorHandling()
                } else {
                    
                    InitialProfileSetupView(selectedGoal: .maintain)
                        .withErrorHandling()
                }
            } else {
                MainTabView()
                    .onAppear {
                        setupInitialData()
                    }
                    .withErrorHandling()
            }
        }
        .modelContainer(sharedModelContainer)
    }
    
    private func setupInitialData() {
        let context = sharedModelContainer.mainContext
        
        
        do {
            let descriptor = FetchDescriptor<Food>()
            let existingFoods = try context.fetch(descriptor)
            if existingFoods.isEmpty {
                SampleData.createSampleFoods(in: context)
            }
        } catch {
            
            
            print("Note: Could not fetch existing foods, likely first run: \(error)")
            
            SampleData.createSampleFoods(in: context)
        }
    }
}
