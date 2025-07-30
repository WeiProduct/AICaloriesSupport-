import Foundation
import SwiftData

@Model
final class UserProfile {
    var id: UUID
    var name: String
    var age: Int
    var gender: Gender
    var height: Double
    var weight: Double
    var goalWeight: Double?
    var activityLevel: ActivityLevel
    var goal: Goal
    var targetCalories: Double?
    var targetProtein: Double?
    var targetCarbs: Double?
    var targetFat: Double?
    var createdAt: Date
    var updatedAt: Date
    
    var bmr: Double {
        if gender == .male {
            return 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * Double(age))
        } else {
            return 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * Double(age))
        }
    }
    
    var tdee: Double {
        bmr * activityLevel.multiplier
    }
    
    var recommendedCalories: Double {
        switch goal {
        case .lose:
            return tdee - 500
        case .maintain:
            return tdee
        case .gain:
            return tdee + 500
        }
    }
    
    init(name: String, age: Int, gender: Gender, height: Double, weight: Double, activityLevel: ActivityLevel = .moderate, goal: Goal = .maintain) {
        self.id = UUID()
        self.name = name
        self.age = age
        self.gender = gender
        self.height = height
        self.weight = weight
        self.activityLevel = activityLevel
        self.goal = goal
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

enum Gender: String, CaseIterable, Codable {
    case male = "male"
    case female = "female"
    
    var localizedName: String {
        switch self {
        case .male: return LocalizationManager.localized("gender.male")
        case .female: return LocalizationManager.localized("gender.female")
        }
    }
}

enum ActivityLevel: String, CaseIterable, Codable {
    case sedentary = "sedentary"
    case light = "light"
    case moderate = "moderate"
    case active = "active"
    case veryActive = "veryActive"
    
    var multiplier: Double {
        switch self {
        case .sedentary: return 1.2
        case .light: return 1.375
        case .moderate: return 1.55
        case .active: return 1.725
        case .veryActive: return 1.9
        }
    }
    
    var localizedName: String {
        switch self {
        case .sedentary: return LocalizationManager.localized("activity.sedentary")
        case .light: return LocalizationManager.localized("activity.light")
        case .moderate: return LocalizationManager.localized("activity.moderate")
        case .active: return LocalizationManager.localized("activity.active")
        case .veryActive: return LocalizationManager.localized("activity.veryActive")
        }
    }
    
    var description: String {
        switch self {
        case .sedentary: return LocalizationManager.localized("activity.sedentary.desc")
        case .light: return LocalizationManager.localized("activity.light.desc")
        case .moderate: return LocalizationManager.localized("activity.moderate.desc")
        case .active: return LocalizationManager.localized("activity.active.desc")
        case .veryActive: return LocalizationManager.localized("activity.veryActive.desc")
        }
    }
}

enum Goal: String, CaseIterable, Codable {
    case lose = "lose"
    case maintain = "maintain"
    case gain = "gain"
    
    var localizedName: String {
        switch self {
        case .lose: return LocalizationManager.localized("goal.lose")
        case .maintain: return LocalizationManager.localized("goal.maintain")
        case .gain: return LocalizationManager.localized("goal.gain")
        }
    }
    
    var description: String {
        switch self {
        case .lose: return LocalizationManager.localized("goal.lose.desc")
        case .maintain: return LocalizationManager.localized("goal.maintain.desc")
        case .gain: return LocalizationManager.localized("goal.gain.desc")
        }
    }
}