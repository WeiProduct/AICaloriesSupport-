import Foundation

public class APIKeyManager {
    public static let shared = APIKeyManager()
    
    
    private let useProxy = true
    
    private init() {}
    
    
    public var openAIKey: String? {
        #if DEBUG
        if useProxy {
            return nil  
        } else {
            return APIKeys.directOpenAIKey
        }
        #else
        return nil  
        #endif
    }
    
    public var openAIEndpoint: String {
        if useProxy {
            return "\(APIKeys.proxyBaseURL)/api/openai"
        } else {
            return "https://api.openai.com/v1/chat/completions"
        }
    }
    
    
    public var geminiKey: String? {
        #if DEBUG
        if useProxy {
            return nil  
        } else {
            return APIKeys.directGeminiKey
        }
        #else
        return nil  
        #endif
    }
    
    public var geminiEndpoint: String {
        if useProxy {
            return "\(APIKeys.proxyBaseURL)/api/gemini"
        } else {
            return "https://generativelanguage.googleapis.com/v1beta"
        }
    }
    
    public var shouldUseProxy: Bool {
        return useProxy
    }
}