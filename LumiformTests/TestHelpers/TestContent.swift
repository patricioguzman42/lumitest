//
//  TestContent.swift
//  LumiformTests
//
//  Created by Patricio Guzman on 19/03/2025.
//

import Foundation
@testable import Lumiform

struct TestContent {
    static let sampleItems: [ContentItem] = {
        (try? [
            ContentItem(title: "Test Item 1"),
            ContentItem(title: "Test Item 2")
        ]) ?? []
    }()
    
    static let invalidData = "invalid".data(using: .utf8)!
}
