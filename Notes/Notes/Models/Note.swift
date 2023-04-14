//
//  Note.swift
//  Notes
//
//  Created by Drew Miller on 4/7/23.
//

import Foundation

struct Note: Identifiable, Hashable, Codable {
    var id: UUID = UUID()
    var modified: Date = Date()
    var text: String = ""
    
    var title: String {
        let firstLine = text.split(separator: "\n").first ?? ""
        let truncated = String(firstLine.prefix(20))
        return truncated.isEmpty ? "New Note" : truncated
    }
    
    func getTags() -> Set<String> {
        var tags = Set<String>()
        
        let words = text.split(separator: " ")
        for word in words {
            if word.hasPrefix("#") {
                tags.insert(String(word.dropFirst()))
            }
        }
        
        return tags
    }
    
    enum CodingKeys: String, CodingKey {
        case id, modified, text
    }
}
