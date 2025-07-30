import UIKit

class FoodRecognitionService {
    static let shared = FoodRecognitionService()
    
    private init() {}
    
    
    private let foodDatabase: [(nameEn: String, nameZh: String, calories: Double, protein: Double, carbs: Double, fat: Double, fiber: Double?, sugar: Double?, sodium: Double?, category: String)] = [
        (nameEn: "Rice", nameZh: "米饭", calories: 130, protein: 2.7, carbs: 28, fat: 0.3, fiber: 1.2, sugar: 0.1, sodium: 5, category: "grain"),
        (nameEn: "Broccoli", nameZh: "西兰花", calories: 34, protein: 2.8, carbs: 7, fat: 0.4, fiber: 2.6, sugar: 1.7, sodium: 33, category: "vegetable"),
        (nameEn: "Chicken Breast", nameZh: "鸡胸肉", calories: 165, protein: 31, carbs: 0, fat: 3.6, fiber: 0, sugar: 0, sodium: 74, category: "protein"),
        (nameEn: "Tomatoes", nameZh: "番茄", calories: 18, protein: 0.9, carbs: 3.9, fat: 0.2, fiber: 1.2, sugar: 2.6, sodium: 5, category: "vegetable")
    ]
    
    func recognizeFood(from image: UIImage, completion: @escaping (Result<RecognitionResult, Error>) -> Void) {
        
        print("Starting OpenAI food recognition...")
        OpenAIService.shared.analyzeFood(image: image) { result in
            switch result {
            case .success(let analysisResult):
                print("OpenAI API success! Found \(analysisResult.foods.count) foods")
                
                let recognizedFoods = analysisResult.foods.map { analyzedFood in
                    RecognizedFood(
                        name: LocalizationManager.shared.selectedLanguage == "en" ? analyzedFood.name : analyzedFood.nameZh,
                        confidence: analyzedFood.confidence,
                        calories: analyzedFood.calories,
                        protein: analyzedFood.protein,
                        carbs: analyzedFood.carbs,
                        fat: analyzedFood.fat,
                        estimatedWeight: analyzedFood.servingSize,
                        fiber: analyzedFood.fiber,
                        sugar: analyzedFood.sugar,
                        sodium: analyzedFood.sodium,
                        servingUnit: analyzedFood.servingUnit,
                        category: analyzedFood.category
                    )
                }
                
                let result = RecognitionResult(
                    foods: recognizedFoods,
                    confidence: analysisResult.confidence,
                    isFromMockData: false
                )
                
                completion(.success(result))
                
            case .failure(let error):
                
                print("OpenAI API failed: \(error.localizedDescription)")
                print("Error details: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    private func fallbackToMockRecognition(for image: UIImage, completion: @escaping (RecognitionResult) -> Void) {
        
        DispatchQueue.global().asyncAfter(deadline: .now() + Constants.mockRecognitionDelay) {
            
            let results = self.generateMockResults(for: image)
            
            DispatchQueue.main.async {
                completion(results)
            }
        }
    }
    
    private func generateMockResults(for image: UIImage) -> RecognitionResult {
        
        let dominantColors = self.getDominantColors(from: image)
        var recognizedFoods: [RecognizedFood] = []
        
        
        let isEnglish = LocalizationManager.shared.selectedLanguage == "en"
        
        
        if dominantColors.contains(where: { $0.isWhite }) {
            
            if let riceData = foodDatabase.first(where: { $0.nameEn == "Rice" }) {
                recognizedFoods.append(RecognizedFood(
                    name: isEnglish ? riceData.nameEn : riceData.nameZh,
                    confidence: 0.85,
                    calories: riceData.calories,
                    protein: riceData.protein,
                    carbs: riceData.carbs,
                    fat: riceData.fat,
                    estimatedWeight: 150,
                    fiber: 1.2,
                    sugar: 0.1,
                    sodium: 5,
                    servingUnit: "g",
                    category: "grain"
                ))
            }
        }
        
        if dominantColors.contains(where: { $0.isGreen }) {
            
            if let broccoliData = foodDatabase.first(where: { $0.nameEn == "Broccoli" }) {
                recognizedFoods.append(RecognizedFood(
                    name: isEnglish ? broccoliData.nameEn : broccoliData.nameZh,
                    confidence: 0.78,
                    calories: broccoliData.calories,
                    protein: broccoliData.protein,
                    carbs: broccoliData.carbs,
                    fat: broccoliData.fat,
                    estimatedWeight: 100,
                    fiber: 2.6,
                    sugar: 1.7,
                    sodium: 33,
                    servingUnit: "g",
                    category: "vegetable"
                ))
            }
        }
        
        if dominantColors.contains(where: { $0.isBrown }) {
            
            if let meatData = foodDatabase.first(where: { $0.nameEn == "Chicken Breast" }) {
                recognizedFoods.append(RecognizedFood(
                    name: isEnglish ? meatData.nameEn : meatData.nameZh,
                    confidence: 0.72,
                    calories: meatData.calories,
                    protein: meatData.protein,
                    carbs: meatData.carbs,
                    fat: meatData.fat,
                    estimatedWeight: 120,
                    fiber: 0,
                    sugar: 0,
                    sodium: 74,
                    servingUnit: "g",
                    category: "protein"
                ))
            }
        }
        
        if dominantColors.contains(where: { $0.isRed }) {
            
            if let tomatoData = foodDatabase.first(where: { $0.nameEn == "Tomatoes" }) {
                recognizedFoods.append(RecognizedFood(
                    name: isEnglish ? tomatoData.nameEn : tomatoData.nameZh,
                    confidence: 0.68,
                    calories: tomatoData.calories,
                    protein: tomatoData.protein,
                    carbs: tomatoData.carbs,
                    fat: tomatoData.fat,
                    estimatedWeight: 80,
                    fiber: 1.2,
                    sugar: 2.6,
                    sodium: 5,
                    servingUnit: "g",
                    category: "vegetable"
                ))
            }
        }
        
        
        if recognizedFoods.isEmpty {
            recognizedFoods = [
                RecognizedFood(
                    name: isEnglish ? "Unknown Food" : "未知食物",
                    confidence: 0.3,
                    calories: 100,
                    protein: 5,
                    carbs: 15,
                    fat: 3,
                    estimatedWeight: 100,
                    fiber: nil,
                    sugar: nil,
                    sodium: nil,
                    servingUnit: "g",
                    category: "other"
                )
            ]
        }
        
        
        let avgConfidence = recognizedFoods.reduce(0) { $0 + $1.confidence } / Double(recognizedFoods.count)
        
        return RecognitionResult(
            foods: recognizedFoods, 
            confidence: avgConfidence,
            isFromMockData: true  
        )
    }
    
    private func getDominantColors(from image: UIImage) -> [UIColor] {
        
        guard let cgImage = image.cgImage else { return [] }
        
        let width = 10
        let height = 10
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        
        guard let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: bitmapInfo
        ) else { return [] }
        
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        
        return [.white, .green, .brown].shuffled()
    }
}


extension UIColor {
    var isWhite: Bool {
        var white: CGFloat = 0
        getWhite(&white, alpha: nil)
        return white > 0.8
    }
    
    var isGreen: Bool {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: nil)
        return g > r && g > b && g > 0.5
    }
    
    var isBrown: Bool {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: nil)
        return r > 0.4 && r < 0.7 && g > 0.2 && g < 0.5 && b < 0.3
    }
    
    var isRed: Bool {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: nil)
        return r > g && r > b && r > 0.5
    }
}