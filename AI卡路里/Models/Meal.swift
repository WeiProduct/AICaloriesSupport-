import Foundation
import SwiftData

@Model
final class Meal {
    var id: UUID
    @Relationship var food: Food?
    var quantity: Double
    var mealType: MealType
    var date: Date
    var notes: String?
    var imageData: Data?
    
    var totalCalories: Double {
        guard let food = food else { return 0 }
        return (food.calories / food.servingSize) * quantity
    }
    
    var totalProtein: Double {
        guard let food = food else { return 0 }
        return (food.protein / food.servingSize) * quantity
    }
    
    var totalCarbs: Double {
        guard let food = food else { return 0 }
        return (food.carbs / food.servingSize) * quantity
    }
    
    var totalFat: Double {
        guard let food = food else { return 0 }
        return (food.fat / food.servingSize) * quantity
    }
    
    init(food: Food?, quantity: Double, mealType: MealType, date: Date = Date()) {
        self.id = UUID()
        self.food = food
        self.quantity = quantity
        self.mealType = mealType
        self.date = date
    }
}

enum MealType: String, CaseIterable, Codable {
    case breakfast
    case lunch
    case dinner
    case snack
    
    var localizedName: String {
        switch self {
        case .breakfast: return LocalizationManager.localized("meal.breakfast")
        case .lunch: return LocalizationManager.localized("meal.lunch")
        case .dinner: return LocalizationManager.localized("meal.dinner")
        case .snack: return LocalizationManager.localized("meal.snack")
        }
    }
    
    var icon: String {
        switch self {
        case .breakfast: return "🌅"
        case .lunch: return "☀️"
        case .dinner: return "🌙"
        case .snack: return "🍿"
        }
    }
    
    var timeRange: String {
        return MealTimeManager.shared.getTimeRangeDescription(for: self)
    }
}