import Foundation
import SwiftData

struct SampleData {
    static func createSampleFoods(in modelContext: ModelContext) {
        
        let isEnglish = LocalizationManager.shared.selectedLanguage == "en"
        
        let foods = [
            Food(name: isEnglish ? "Apple" : "苹果", calories: 52, protein: 0.3, carbs: 14, fat: 0.2, servingSize: 100, servingUnit: "g", category: .fruit),
            Food(name: isEnglish ? "Banana" : "香蕉", calories: 89, protein: 1.1, carbs: 23, fat: 0.3, servingSize: 100, servingUnit: "g", category: .fruit),
            Food(name: isEnglish ? "Chicken Breast" : "鸡胸肉", calories: 165, protein: 31, carbs: 0, fat: 3.6, servingSize: 100, servingUnit: "g", category: .protein),
            Food(name: isEnglish ? "Rice" : "米饭", calories: 130, protein: 2.7, carbs: 28, fat: 0.3, servingSize: 100, servingUnit: "g", category: .grain),
            Food(name: isEnglish ? "Broccoli" : "西兰花", calories: 34, protein: 2.8, carbs: 7, fat: 0.4, servingSize: 100, servingUnit: "g", category: .vegetable),
            Food(name: isEnglish ? "Eggs" : "鸡蛋", calories: 155, protein: 13, carbs: 1.1, fat: 11, servingSize: 100, servingUnit: "g", category: .protein),
            Food(name: isEnglish ? "Milk" : "牛奶", calories: 42, protein: 3.4, carbs: 5, fat: 1, servingSize: 100, servingUnit: "ml", category: .dairy),
            Food(name: isEnglish ? "Whole Wheat Bread" : "全麦面包", calories: 247, protein: 9, carbs: 47, fat: 3.4, servingSize: 100, servingUnit: "g", category: .grain),
            Food(name: isEnglish ? "Yogurt" : "酸奶", calories: 59, protein: 10, carbs: 3.6, fat: 0.4, servingSize: 100, servingUnit: "g", category: .dairy),
            Food(name: isEnglish ? "Orange" : "橙子", calories: 47, protein: 0.9, carbs: 12, fat: 0.1, servingSize: 100, servingUnit: "g", category: .fruit)
        ]
        
        for food in foods {
            modelContext.insert(food)
        }
        
        do {
            try modelContext.save()
        } catch {
            ErrorHandlingService.shared.handle(error, context: "Saving sample foods")
        }
    }
}