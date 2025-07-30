import Foundation


public struct APIKeys {
    
    public static let proxyBaseURL = "https://ai-calorie-proxy.vercel.app"
    
    
    public static var directOpenAIKey: String? {
        ProcessInfo.processInfo.environment["OPENAI_API_KEY"]
    }
    
    public static var directGeminiKey: String? {
        ProcessInfo.processInfo.environment["GEMINI_API_KEY"]
    }
}