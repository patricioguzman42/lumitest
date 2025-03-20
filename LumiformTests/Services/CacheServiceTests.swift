import Testing
import Foundation
@testable import Lumiform

class CacheServiceTests {
    private var cacheService: CacheService
    private let fileManager: FileManager
    private let testFileName: String
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    init() {
        fileManager = FileManager.default
        testFileName = "test_cache_\(UUID().uuidString).json"
        encoder = JSONEncoder()
        decoder = JSONDecoder()
        
        cacheService = CacheService(
            fileManager: fileManager,
            cacheFileName: testFileName,
            encoder: encoder,
            decoder: decoder
        )
    }
    
    deinit {
        if let cacheUrl = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
            .first?.appendingPathComponent(testFileName) {
            try? fileManager.removeItem(at: cacheUrl)
        }
    }
    
    @Test func saveContent_ValidContent_SavesSuccessfully() async throws {
        print("\n🧪 Starting saveContent_ValidContent_SavesSuccessfully test")
        let testItem = try ContentItem(title: "Test Item")
        let items = [testItem]
        
        print("📦 Test item created: \(testItem)")
        try cacheService.saveContent(items)
        print("🔍 Attempting to load saved content")
        let loadedContent = try cacheService.loadContent()
        
        print("📊 Loaded content count: \(loadedContent.count)")
        #expect(!loadedContent.isEmpty)
        #expect(loadedContent.count == 1)
        #expect(loadedContent[0].title == testItem.title)
    }
    
    @Test func loadContent_EmptyCache_ThrowsError() async throws {
        #expect(throws: CacheError.loadFailed) {
            try cacheService.loadContent()
        }
    }
    
    @Test func clearCache_ExistingCache_RemovesCache() async throws {
        try cacheService.saveContent(TestContent.sampleItems)
        try cacheService.clearCache()
        
        #expect(throws: CacheError.loadFailed) {
            try cacheService.loadContent()
        }
    }
    
    @Test func saveAndLoad_MultipleTimes_ReturnsLatestContent() async throws {
        try cacheService.saveContent(TestContent.sampleItems)
        
        let newId = UUID()
        let newItems = [try ContentItem(id: newId, title: "New Item")]
        try cacheService.saveContent(newItems)
        
        let loadedContent = try cacheService.loadContent()
        #expect(loadedContent.count == 1)
        #expect(loadedContent[0].title == "New Item")
    }
}
