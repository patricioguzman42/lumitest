//
//  ContentRepository.swift
//  Lumiform
//
//  Created by Patricio Guzman on 19/03/2025.
//

import Foundation

protocol ContentRepositoryProtocol {
    func refreshContent() async throws -> [ContentItem]
    func getContent() async throws -> [ContentItem]
}

class ContentRepository: ContentRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    private let cacheService: CacheServiceProtocol
    private let reachabilityService: ReachabilityServiceProtocol
    
    init(networkService: NetworkServiceProtocol,
         cacheService: CacheServiceProtocol,
         reachabilityService: ReachabilityServiceProtocol) {
        self.networkService = networkService
        self.cacheService = cacheService
        self.reachabilityService = reachabilityService
        self.reachabilityService.startMonitoring()
    }
    
    func refreshContent() async throws -> [ContentItem] {
        if reachabilityService.isConnected {
            let content = try await networkService.fetchContent()
            try? cacheService.saveContent(content)
            return content
        }
        return try await getContent()
    }
    
    func getContent() async throws -> [ContentItem] {
        if reachabilityService.isConnected {
            return try await networkService.fetchContent()
        }
        return try cacheService.loadContent()
    }
}
