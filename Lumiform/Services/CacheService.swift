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
    private let fileManager: FileManager
    private let cacheFileName: String
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    init(
        fileManager: FileManager = .default,
        cacheFileName: String = "content_cache.json",
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.fileManager = fileManager
        self.cacheFileName = cacheFileName
        self.encoder = encoder
        self.decoder = decoder
    }
    
    private var cacheURL: URL? {
        fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent(cacheFileName)
    }
    
    func saveContent(_ content: [ContentItem]) throws {
        guard let url = cacheURL else {
            throw CacheError.invalidCacheURL
        }
        
        do {
            let data = try encoder.encode(content)
            try data.write(to: url, options: .atomic)
            
            guard fileManager.fileExists(atPath: url.path) else {
                throw CacheError.saveFailed
            }
        } catch {
            throw CacheError.saveFailed
        }
    }
    
    func loadContent() throws -> [ContentItem] {
        guard let url = cacheURL else {
            throw CacheError.invalidCacheURL
        }
        
        guard fileManager.fileExists(atPath: url.path) else {
            throw CacheError.loadFailed
        }
        
        do {
            let data = try Data(contentsOf: url)
            let content = try decoder.decode([ContentItem].self, from: data)
            return content
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
