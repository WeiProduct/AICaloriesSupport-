import Foundation

class SearchService {
    static let shared = SearchService()
    
    private init() {}
    
    
    func toPinyin(_ chinese: String) -> String {
        let mutableString = NSMutableString(string: chinese)
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        return mutableString as String
    }
    
    
    func getPinyinInitials(_ chinese: String) -> String {
        let pinyin = toPinyin(chinese)
        let words = pinyin.components(separatedBy: " ")
        return words.compactMap { $0.first }.map { String($0) }.joined().lowercased()
    }
    
    
    func smartSearch(query: String, in items: [SearchableItem]) -> [SearchableItem] {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        guard !trimmedQuery.isEmpty else { return [] }
        
        return items.filter { item in
            
            if item.searchableText.localizedCaseInsensitiveContains(trimmedQuery) {
                return true
            }
            
            
            let pinyin = toPinyin(item.searchableText).lowercased()
            if pinyin.contains(trimmedQuery) {
                return true
            }
            
            
            let initials = getPinyinInitials(item.searchableText)
            if initials.contains(trimmedQuery) {
                return true
            }
            
            
            if let secondaryText = item.secondarySearchableText {
                if secondaryText.localizedCaseInsensitiveContains(trimmedQuery) {
                    return true
                }
                
                let secondaryPinyin = toPinyin(secondaryText).lowercased()
                if secondaryPinyin.contains(trimmedQuery) {
                    return true
                }
                
                let secondaryInitials = getPinyinInitials(secondaryText)
                if secondaryInitials.contains(trimmedQuery) {
                    return true
                }
            }
            
            return false
        }
    }
    
    
    func rankedSearch(query: String, in items: [SearchableItem]) -> [SearchableItem] {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        guard !trimmedQuery.isEmpty else { return [] }
        
        let results = items.compactMap { item -> (item: SearchableItem, score: Int)? in
            var score = 0
            
            
            if item.searchableText.lowercased() == trimmedQuery {
                score = 100
            }
            
            else if item.searchableText.lowercased().hasPrefix(trimmedQuery) {
                score = 80
            }
            
            else if item.searchableText.localizedCaseInsensitiveContains(trimmedQuery) {
                score = 60
            }
            
            else if toPinyin(item.searchableText).lowercased() == trimmedQuery {
                score = 50
            }
            
            else if toPinyin(item.searchableText).lowercased().hasPrefix(trimmedQuery) {
                score = 40
            }
            
            else if toPinyin(item.searchableText).lowercased().contains(trimmedQuery) {
                score = 30
            }
            
            else if getPinyinInitials(item.searchableText).contains(trimmedQuery) {
                score = 20
            }
            
            else if let secondaryText = item.secondarySearchableText {
                if secondaryText.localizedCaseInsensitiveContains(trimmedQuery) ||
                   toPinyin(secondaryText).lowercased().contains(trimmedQuery) {
                    score = 10
                }
            }
            
            return score > 0 ? (item, score) : nil
        }
        
        return results.sorted { $0.score > $1.score }.map { $0.item }
    }
    
    
    func highlightedText(for text: String, query: String) -> AttributedString {
        var attributedString = AttributedString(text)
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedQuery.isEmpty else { return attributedString }
        
        
        var ranges: [Range<AttributedString.Index>] = []
        
        
        if let range = attributedString.range(of: trimmedQuery, options: [.caseInsensitive, .diacriticInsensitive]) {
            ranges.append(range)
        }
        
        
        
        
        for range in ranges {
            attributedString[range].backgroundColor = .yellow.opacity(0.3)
            attributedString[range].foregroundColor = .primary
        }
        
        return attributedString
    }
}


protocol SearchableItem {
    var searchableText: String { get }
    var secondarySearchableText: String? { get }
}