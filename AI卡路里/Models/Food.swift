import Foundation
import SwiftData

@Model
final class Food {
    var id: UUID
    var name: String
    var brand: String?
    var barcode: String?
    var calories: Double
    var protein: Double
    var carbs: Double
    var fat: Double
    var fiber: Double?
    var sugar: Double?
    var sodium: Double?
    var servingSize: Double
    var servingUnit: String
    var imageData: Data?
    var categoryRawValue: String
    var createdAt: Date
    var isFavorite: Bool
    
    var category: FoodCategory {
        get { FoodCategory(rawValue: categoryRawValue) ?? .other }
        set { categoryRawValue = newValue.rawValue }
    }
    
    init(
        name: String,
        calories: Double,
        protein: Double,
        carbs: Double,
        fat: Double,
        servingSize: Double = 100,
        servingUnit: String = "g",
        category: FoodCategory = .other
    ) {
        self.id = UUID()
        self.name = name
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fat = fat
        self.servingSize = servingSize
        self.servingUnit = servingUnit
        self.categoryRawValue = category.rawValue
        self.createdAt = Date()
        self.isFavorite = false
    }
}


extension Food: SearchableItem {
    var searchableText: String {
        name
    }
    
    var secondarySearchableText: String? {
        brand
    }
}

enum FoodCategory: String, CaseIterable, Codable {
    case fruit = "fruit"
    case vegetable = "vegetable"
    case grain = "grain"
    case protein = "protein"
    case dairy = "dairy"
    case beverage = "beverage"
    case snack = "snack"
    case other = "other"
    
    var localizedName: String {
        switch self {
        case .fruit: return LocalizationManager.localized("food.category.fruit")
        case .vegetable: return LocalizationManager.localized("food.category.vegetable")
        case .grain: return LocalizationManager.localized("food.category.grain")
        case .protein: return LocalizationManager.localized("food.category.protein")
        case .dairy: return LocalizationManager.localized("food.category.dairy")
        case .beverage: return LocalizationManager.localized("food.category.beverage")
        case .snack: return LocalizationManager.localized("food.category.snack")
        case .other: return LocalizationManager.localized("food.category.other")
        }
    }
    
    var icon: String {
        switch self {
        case .fruit: return "🍎"
        case .vegetable: return "🥬"
        case .grain: return "🌾"
        case .protein: return "🥩"
        case .dairy: return "🥛"
        case .beverage: return "🥤"
        case .snack: return "🍿"
        case .other: return "🍽️"
        }
    }
}