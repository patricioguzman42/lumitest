//
//  MockContentRepository.swift
//  Lumiform
//
//  Created by Patricio Guzman on 20/03/2025.
//

import Testing
import Foundation
@testable import Lumiform

class MockContentRepository: ContentRepositoryProtocol {
    var shouldThrowError = false
    var error: Error = NetworkError.invalidURL
    
    func refreshContent() async throws -> [ContentItem] {
        if shouldThrowError {
            throw error
        }
        return [try ContentItem(title: "Test Item")]
    }
    
    func getContent() async throws -> [ContentItem] {
        if shouldThrowError {
            throw error
        }
        return [try ContentItem(title: "Test Item")]
    }
}
