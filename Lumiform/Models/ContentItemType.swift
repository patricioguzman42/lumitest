//
//  ContentItemType.swift
//  Lumiform
//
//  Created by Patricio Guzman on 19/03/2025.
//

import Foundation

enum ContentItemType: Codable {
    case page
    case section
    case question(QuestionType)
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: TypeCodingKeys.self)
        
        switch self {
        case .page:
            try container.encode("page", forKey: .type)
        case .section:
            try container.encode("section", forKey: .type)
        case .question:
            try container.encode("text", forKey: .type)
        }
    }
    
    private enum TypeCodingKeys: String, CodingKey {
        case type
    }
}
