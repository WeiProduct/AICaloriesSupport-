import SwiftUI
import SwiftData
import Observation

@Observable
class DailySummaryViewModel {
    private var modelContext: ModelContext?
    
    var todayLog: DailyLog?
    var meals: [Meal] = []
    var waterIntake: Double = 0
    var currentWeight: Double = 0
    var userProfile: UserProfile?
    
    var isWeightLossMode: Bool {
        return userProfile?.goal == .lose
    }
    
    var caloriesRemaining: Double {
        guard let log = todayLog else { return Constants.defaultTargetCalories }
        if isWeightLossMode {
            
            return max(0, log.targetCalories - log.totalCalories)
        } else {
            
            return max(0, log.targetCalories - log.totalCalories)
        }
    }
    
    var calorieProgress: Double {
        guard let log = todayLog else { return 0 }
        return min(1.0, log.totalCalories / log.targetCalories)
    }
    
    var isOverLimit: Bool {
        guard let log = todayLog else { return false }
        return isWeightLossMode && (log.totalCalories > log.targetCalories * 0.8)
    }
    
    var mealsByType: [MealType: [Meal]] {
        Dictionary(grouping: meals, by: { $0.mealType })
    }
    
    func setup(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadTodayData()
    }
    
    func loadTodayData() {
        guard let modelContext = modelContext else { return }
        
        
        userProfile = getUserProfile()
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let logPredicate = #Predicate<DailyLog> { log in
            log.date >= startOfDay && log.date < endOfDay
        }
        
        let logDescriptor = FetchDescriptor<DailyLog>(predicate: logPredicate)
        
        do {
            todayLog = try modelContext.fetch(logDescriptor).first ?? createTodayLog()
            
            let mealPredicate = #Predicate<Meal> { meal in
                meal.date >= startOfDay && meal.date < endOfDay
            }
            
            let mealDescriptor = FetchDescriptor<Meal>(
                predicate: mealPredicate,
                sortBy: [SortDescriptor(\.date)]
            )
            
            meals = try modelContext.fetch(mealDescriptor)
            waterIntake = todayLog?.water ?? 0
            currentWeight = todayLog?.weight ?? userProfile?.weight ?? 0
        } catch {
            ErrorHandlingService.shared.handle(error, context: "Loading today's data")
        }
    }
    
    private func createTodayLog() -> DailyLog {
        guard let modelContext = modelContext else { return DailyLog() }
        
        let profile = getUserProfile()
        let log = DailyLog(
            targetCalories: profile?.targetCalories ?? profile?.recommendedCalories ?? Constants.defaultTargetCalories
        )
        
        modelContext.insert(log)
        
        do {
            try modelContext.save()
        } catch {
            ErrorHandlingService.shared.handle(error, context: "Creating today's log")
        }
        
        return log
    }
    
    private func getUserProfile() -> UserProfile? {
        guard let modelContext = modelContext else { return nil }
        
        let descriptor = FetchDescriptor<UserProfile>(
            sortBy: [SortDescriptor(\.updatedAt, order: .reverse)]
        )
        
        do {
            return try modelContext.fetch(descriptor).first
        } catch {
            ErrorHandlingService.shared.handle(error, context: "Fetching user profile")
            return nil
        }
    }
    
    func updateWaterIntake(_ amount: Double) {
        guard let modelContext = modelContext,
              let log = todayLog else { return }
        
        log.water += amount
        waterIntake = log.water
        
        do {
            try modelContext.save()
        } catch {
            ErrorHandlingService.shared.handle(error, context: "Updating water intake")
        }
    }
    
    func deleteMeal(_ meal: Meal) {
        guard let modelContext = modelContext else { return }
        
        modelContext.delete(meal)
        
        if let index = meals.firstIndex(where: { $0.id == meal.id }) {
            meals.remove(at: index)
        }
        
        if let log = todayLog,
           let index = log.meals.firstIndex(where: { $0.id == meal.id }) {
            log.meals.remove(at: index)
        }
        
        do {
            try modelContext.save()
        } catch {
            ErrorHandlingService.shared.handle(error, context: "Deleting meal")
        }
    }
    
    func updateWeight(_ weight: Double) {
        guard let modelContext = modelContext,
              let log = todayLog else { return }
        
        log.weight = weight
        currentWeight = weight
        
        do {
            try modelContext.save()
        } catch {
            ErrorHandlingService.shared.handle(error, context: "Updating weight")
        }
    }
}