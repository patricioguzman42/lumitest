//
//  CacheService.swift
//  Lumiform
//
//  Created by Patricio Guzman on 19/03/2025.
//

import Foundation

protocol CacheServiceProtocol {
    func saveContent(_ content: [ContentItem]) throws
    func loadContent() throws -> [ContentItem]
    func clearCache() throws
}

class CacheService: CacheServiceProtocol {
    private let fileManager = FileManager.default
    private let cacheFileName = "content_cache.json"
    
    private var cacheURL: URL? {
        fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent(cacheFileName)
    }
    
    func saveContent(_ content: [ContentItem]) throws {
        guard let url = cacheURL else {
            throw CacheError.invalidCacheURL
        }
        
        let data = try JSONEncoder().encode(content)
        try data.write(to: url)
    }
    
    func loadContent() throws -> [ContentItem] {
        guard let url = cacheURL else {
            throw CacheError.invalidCacheURL
        }
        
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([ContentItem].self, from: data)
        } catch {
            throw CacheError.loadFailed
        }
    }
    
    func clearCache() throws {
        guard let url = cacheURL,
              fileManager.fileExists(atPath: url.path) else {
            return
        }
        try fileManager.removeItem(at: url)
    }
}

enum CacheError: Error {
    case invalidCacheURL
    case saveFailed
    case loadFailed
}
