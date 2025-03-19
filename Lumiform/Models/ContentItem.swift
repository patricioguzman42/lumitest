//
//  ContentItem.swift
//  Lumiform
//
//  Created by Patricio Guzman on 19/03/2025.
//

import Foundation

struct ContentItem: Identifiable, Decodable {
    let id: UUID = UUID()
    let type: ContentItemType
    let title: String
    let items: [ContentItem]?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.title = try container.decode(String.self, forKey: .title)
        
        let type = try container.decode(String.self, forKey: .type)
        switch type {
        case "page":
            self.type = .page
        case "section":
            self.type = .section
        case "text":
            self.type = .question(try QuestionType(from: decoder))
        case "image":
            self.type = .question(try QuestionType(from: decoder))
        default:
            throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Invalid type")
        }
        
        self.items = try container.decodeIfPresent([ContentItem].self, forKey: .items)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case title
        case items
    }
}

extension ContentItem {
    var isPage: Bool {
        if case .page = type { return true }
        return false
    }
    
    var isSection: Bool {
        if case .section = type { return true }
        return false
    }
    
    var isQuestion: Bool {
        if case .question = type { return true }
        return false
    }
    
    var isTextQuestion: Bool {
        if case .question(.text) = type { return true }
        return false
    }
    
    var isImageQuestion: Bool {
        if case .question(.image) = type { return true }
        return false
    }
    
    var questionTitle: String? {
        switch type {
        case .question(.text(let title)): return title
        case .question(.image(let title, _)): return title
        default: return nil
        }
    }
    
    var questionImageURL: URL? {
        if case .question(.image(_, let src)) = type { return src }
        return nil
    }
}
