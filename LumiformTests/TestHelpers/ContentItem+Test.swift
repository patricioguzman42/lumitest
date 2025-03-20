//
//  ContentItem+Test.swift
//  LumiformTests
//
//  Created by Patricio Guzman on 19/03/2025.
//

import Foundation
@testable import Lumiform

extension ContentItem {
    init(title: String) throws {
        let json = """
        {
            "id": "\(UUID().uuidString)",
            "title": "\(title)",
            "type": "text"
        }
        """.data(using: .utf8)!
        
        self = try JSONDecoder().decode(ContentItem.self, from: json)
    }
    
    init(id: UUID, title: String) throws {
        let json = """
        {
            "id": "\(id.uuidString)",
            "title": "\(title)",
            "type": "text"
        }
        """.data(using: .utf8)!
        
        self = try JSONDecoder().decode(ContentItem.self, from: json)
    }
}
