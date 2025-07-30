import Foundation
import UIKit

class OpenAIService {
    static let shared = OpenAIService()
    private let apiManager = APIKeyManager.shared
    
    private init() {}
    
    func analyzeFood(image: UIImage, completion: @escaping (Result<FoodAnalysisResult, Error>) -> Void) {
        print("OpenAIService: Starting food analysis...")
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("OpenAIService: Failed to process image")
            completion(.failure(OpenAIError.imageProcessingFailed))
            return
        }
        print("OpenAIService: Image processed, size: \(imageData.count) bytes")
        
        let base64Image = imageData.base64EncodedString()
        
        let messages: [[String: Any]] = [
            [
                "role": "system",
                "content": "You are a nutrition expert AI assistant. Analyze food images and provide detailed nutritional information. Always respond in JSON format with the exact structure specified."
            ],
            [
                "role": "user",
                "content": [
                    [
                        "type": "text",
                        "text": """
                        Analyze this food image and identify all foods visible. For each food item, estimate its ACTUAL portion size and provide nutritional information.

                        CRITICAL INSTRUCTIONS:
                        1. servingSize must be the ACTUAL amount visible in the image, NOT a standard 100g portion
                        2. All nutritional values (calories, protein, carbs, fat, etc.) must be calculated for the ACTUAL servingSize
                        3. Be realistic about portions:
                           - Whole roasted chicken: 1000-1500g
                           - Half chicken: 500-750g
                           - Chicken breast: 150-250g
                           - Steak: 200-400g
                           - Bowl of rice: 150-250g
                           - Plate of vegetables: 100-300g
                           - Whole fish: 300-800g depending on size

                        Return JSON in this exact format:
                        {
                            "foods": [
                                {
                                    "name": "English name",
                                    "nameZh": "中文名",
                                    "confidence": 0.9,
                                    "calories": [total calories for the actual portion],
                                    "protein": [grams of protein for the actual portion],
                                    "carbs": [grams of carbs for the actual portion],
                                    "fat": [grams of fat for the actual portion],
                                    "fiber": [grams of fiber for the actual portion],
                                    "sugar": [grams of sugar for the actual portion],
                                    "sodium": [mg of sodium for the actual portion],
                                    "servingSize": [actual portion size in the image],
                                    "servingUnit": "g",
                                    "category": "protein|vegetable|grain|fruit|dairy|beverage|snack|other"
                                }
                            ],
                            "totalCalories": [sum of all foods' calories],
                            "confidence": [overall confidence 0-1]
                        }

                        Example: If you see a whole roasted chicken that looks like 1200g, return:
                        - servingSize: 1200
                        - calories: 2580 (for 1200g, not 215 per 100g)
                        - protein: 276 (for 1200g, not 23 per 100g)
                        """
                    ],
                    [
                        "type": "image_url",
                        "image_url": [
                            "url": "data:image/jpeg;base64,\(base64Image)",
                            "detail": "high"
                        ]
                    ]
                ] as Any
            ]
        ]
        
        let requestBody: [String: Any] = [
            "model": "gpt-4o",
            "messages": messages,
            "max_tokens": 1000,
            "temperature": 0.3
        ]
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: requestBody) else {
            completion(.failure(OpenAIError.requestCreationFailed))
            return
        }
        
        let endpoint = apiManager.openAIEndpoint
        guard let url = URL(string: endpoint) else {
            completion(.failure(OpenAIError.requestCreationFailed))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        if let apiKey = apiManager.openAIKey {
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        }
        
        request.httpBody = httpBody
        request.timeoutInterval = 30
        
        print("OpenAIService: Sending request to OpenAI API...")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("OpenAIService: Network error: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                print("OpenAIService: No data received")
                DispatchQueue.main.async {
                    completion(.failure(OpenAIError.noData))
                }
                return
            }
            
            print("OpenAIService: Received data: \(data.count) bytes")
            if let responseString = String(data: data, encoding: .utf8) {
                print("OpenAIService: Response: \(responseString.prefix(500))...")
            }
            
            do {
                let response = try JSONDecoder().decode(OpenAIResponse.self, from: data)
                
                guard let content = response.choices.first?.message.content else {
                    DispatchQueue.main.async {
                        completion(.failure(OpenAIError.invalidResponse))
                    }
                    return
                }
                
                
                
                let cleanedContent = content
                    .replacingOccurrences(of: "```json\n", with: "")
                    .replacingOccurrences(of: "\n```", with: "")
                    .replacingOccurrences(of: "```", with: "")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                
                guard let jsonData = cleanedContent.data(using: .utf8),
                      let analysisResult = try? JSONDecoder().decode(FoodAnalysisResult.self, from: jsonData) else {
                    print("OpenAIService: Failed to parse JSON: \(cleanedContent)")
                    DispatchQueue.main.async {
                        completion(.failure(OpenAIError.parsingFailed))
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    completion(.success(analysisResult))
                }
                
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}



struct OpenAIResponse: Codable {
    let choices: [Choice]
    
    struct Choice: Codable {
        let message: Message
    }
    
    struct Message: Codable {
        let content: String
    }
}

struct FoodAnalysisResult: Codable {
    let foods: [AnalyzedFood]
    let totalCalories: Double
    let confidence: Double
}

struct AnalyzedFood: Codable {
    let name: String
    let nameZh: String
    let confidence: Double
    let calories: Double
    let protein: Double
    let carbs: Double
    let fat: Double
    let fiber: Double?
    let sugar: Double?
    let sodium: Double?
    let servingSize: Double
    let servingUnit: String
    let category: String
}

enum OpenAIError: LocalizedError {
    case imageProcessingFailed
    case requestCreationFailed
    case noData
    case invalidResponse
    case parsingFailed
    
    var errorDescription: String? {
        switch self {
        case .imageProcessingFailed:
            return "Failed to process image"
        case .requestCreationFailed:
            return "Failed to create request"
        case .noData:
            return "No data received"
        case .invalidResponse:
            return "Invalid response from server"
        case .parsingFailed:
            return "Failed to parse response"
        }
    }
}