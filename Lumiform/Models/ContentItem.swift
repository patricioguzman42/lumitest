//
//  ContentItem.swift
//  Lumiform
//
//  Created by Patricio Guzman on 19/03/2025.
//

import Foundation

struct ContentItem: Identifiable, Codable {
    let id: UUID = UUID()
    let type: ContentItemType
    let title: String
    let items: [ContentItem]?
    
    enum CodingKeys: String, CodingKey {
        case type
        case title
        case items
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        
        switch type {
        case .page:
            try container.encode("page", forKey: .type)
        case .section:
            try container.encode("section", forKey: .type)
        case .question(let questionType):
            switch questionType {
            case .text:
                try container.encode("text", forKey: .type)
            case .image(_, let src):
                try container.encode("image", forKey: .type)
                var container = encoder.container(keyedBy: QuestionCodingKeys.self)
                try container.encode(src.absoluteString, forKey: .src)
            }
        }
        
        try container.encodeIfPresent(items, forKey: .items)
    }
    
    private enum QuestionCodingKeys: String, CodingKey {
        case src
    }
    
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
