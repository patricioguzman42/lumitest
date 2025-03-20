import Testing
import Foundation
@testable import Lumiform

struct ContentViewModelTests {
    private var contentViewModel: ContentViewModel!
    private var mockRepository: MockContentRepository!
    
    init() {
        mockRepository = MockContentRepository()
        contentViewModel = ContentViewModel(repository: mockRepository)
    }
    
    @Test func loadContent_Success_UpdatesState() async {
        await contentViewModel.loadContent()
        
        if case let .loaded(items) = contentViewModel.state {
            #expect(items.count == 1)
            #expect(items[0].title == "Test Item")
        } else {
            Issue.record("Expected loaded state")
        }
    }
    
    @Test func loadContent_NetworkError_UpdatesStateWithError() async {
        mockRepository.shouldThrowError = true
        mockRepository.error = NetworkError.invalidResponse
        
        await contentViewModel.loadContent()
        
        if case let .error(message) = contentViewModel.state {
            #expect(message == "Invalid server response")
        } else {
            Issue.record("Expected error state")
        }
    }
    
    @Test func refreshContent_Success_UpdatesState() async {
        await contentViewModel.refreshContent()
        
        if case let .loaded(items) = contentViewModel.state {
            #expect(items.count == 1)
            #expect(items[0].title == "Test Item")
        } else {
            Issue.record("Expected loaded state")
        }
    }
    
    @Test func refreshContent_DecodingError_UpdatesStateWithError() async {
        mockRepository.shouldThrowError = true
        mockRepository.error = NetworkError.decodingError
        
        await contentViewModel.refreshContent()
        
        if case let .error(message) = contentViewModel.state {
            #expect(message == "Could not process the data")
        } else {
            Issue.record("Expected error state")
        }
    }
    
    @Test func loadContent_Loading_ShowsLoadingState() async {
        var states: [ContentState] = []
        
        await confirmation("Content loads through loading state") { done in
            states.append(contentViewModel.state)
            await contentViewModel.loadContent()
            states.append(contentViewModel.state)
            done()
        }
        
        #expect(states[0] == .idle)
        if case .loaded = states[1] {
            #expect(true)
        } else {
            Issue.record("Expected loaded state")
        }
    }
}

// Add at the end of the file
extension ContentState: @retroactive Equatable {
    public static func == (lhs: ContentState, rhs: ContentState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle),
             (.loading, .loading):
            return true
        case let (.loaded(lhsItems), .loaded(rhsItems)):
            return lhsItems.count == rhsItems.count
        case let (.error(lhsMessage), .error(rhsMessage)):
            return lhsMessage == rhsMessage
        default:
            return false
        }
    }
}
