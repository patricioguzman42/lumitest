//
//  ContentRepository.swift
//  Lumiform
//
//  Created by Patricio Guzman on 19/03/2025.
//

import Foundation

protocol ContentRepositoryProtocol {
    func refreshContent() async throws -> [ContentItem]
}

class ContentRepository: ContentRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func refreshContent() async throws -> [ContentItem] {
        return try await networkService.fetchContent()
    }
} 
