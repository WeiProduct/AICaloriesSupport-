import Foundation
import SwiftData

@Model
final class DailyLog {
    var id: UUID
    var date: Date
    @Relationship(deleteRule: .cascade) var meals: [Meal] = []
    var targetCalories: Double
    var targetProtein: Double
    var targetCarbs: Double
    var targetFat: Double
    var water: Double
    var weight: Double?
    var notes: String?
    
    var totalCalories: Double {
        meals.reduce(0) { $0 + $1.totalCalories }
    }
    
    var totalProtein: Double {
        meals.reduce(0) { $0 + $1.totalProtein }
    }
    
    var totalCarbs: Double {
        meals.reduce(0) { $0 + $1.totalCarbs }
    }
    
    var totalFat: Double {
        meals.reduce(0) { $0 + $1.totalFat }
    }
    
    var calorieProgress: Double {
        min(totalCalories / targetCalories, 1.0)
    }
    
    var proteinProgress: Double {
        min(totalProtein / targetProtein, 1.0)
    }
    
    var carbsProgress: Double {
        min(totalCarbs / targetCarbs, 1.0)
    }
    
    var fatProgress: Double {
        min(totalFat / targetFat, 1.0)
    }
    
    init(date: Date = Date(), targetCalories: Double = Constants.defaultTargetCalories) {
        self.id = UUID()
        self.date = date
        self.meals = []
        self.targetCalories = targetCalories
        self.targetProtein = targetCalories * Constants.defaultProteinRatio / 4
        self.targetCarbs = targetCalories * Constants.defaultCarbsRatio / 4
        self.targetFat = targetCalories * Constants.defaultFatRatio / 9
        self.water = 0
    }
}