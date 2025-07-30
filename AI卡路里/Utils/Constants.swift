import Foundation

enum Constants {
    
    static let defaultTargetCalories: Double = 2000
    static let defaultProteinRatio: Double = 0.3  
    static let defaultCarbsRatio: Double = 0.5    
    static let defaultFatRatio: Double = 0.2      
    
    
    static let defaultWaterTarget: Double = 2000  
    static let cupVolume: Double = 250           
    static let bottleVolume: Double = 500         
    
    
    static let iconSize: Double = 60
    static let buttonHeight: Double = 50
    static let cornerRadius: Double = 10
    static let shadowRadius: Double = 5
    
    
    static let animationDuration: Double = 0.3
    static let hapticDelay: Double = 0.1
    
    
    static let chartHeight: Double = 200
    static let chartAnimationDuration: Double = 0.5
    
    
    static let maxFoodNameLength: Int = 50
    static let maxNoteLength: Int = 200
    static let recentFoodsLimit: Int = 10
    static let historyDaysLimit: Int = 30
    
    
    static let recognitionConfidenceThreshold: Double = 0.7
    static let mockRecognitionDelay: Double = 1.5
    
    
    static let weightChangeSmall: Double = 0.2
    static let weightChangeMedium: Double = 0.5
    static let poundsToKgRatio: Double = 0.453592
    static let kgToPoundsRatio: Double = 2.20462
    
    
    static let bmiUnderweight: Double = 18.5
    static let bmiNormal: Double = 24.0
    static let bmiOverweight: Double = 28.0
    
    
    static let defaultWaterReminderHours = [8, 10, 12, 14, 16, 18, 20, 22]
    static let defaultBreakfastHour = 8
    static let defaultLunchHour = 12
    static let defaultDinnerHour = 19
    
    
    static let searchDebounceDelay: Double = 0.3
    static let minSearchLength: Int = 1
}