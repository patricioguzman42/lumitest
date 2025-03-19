//
//  QuestionType.swift
//  Lumiform
//
//  Created by Patricio Guzman on 19/03/2025.
//

import Foundation

enum QuestionType: Decodable {
    case text(title: String)
    case image(title: String, src: URL)
    
    private enum CodingKeys: String, CodingKey {
        case type
        case title
        case src
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        
        switch type {
        case "text":
            let title = try container.decode(String.self, forKey: .title)
            self = .text(title: title)
        case "image":
            let title = try container.decode(String.self, forKey: .title)
            let srcString = try container.decode(String.self, forKey: .src)
            guard let url = URL(string: srcString) else {
                throw DecodingError.dataCorruptedError(forKey: .src, in: container, debugDescription: "Invalid URL")
            }
            self = .image(title: title, src: url)
        default:
            throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Invalid question type")
        }
    }
}
