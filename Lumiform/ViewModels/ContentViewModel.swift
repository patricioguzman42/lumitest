//
//  ContentViewModel.swift
//  Lumiform
//
//  Created by Patricio Guzman on 19/03/2025.
//

import Foundation
import SwiftUI

enum ContentState {
    case idle
    case loading
    case loaded([ContentItem])
    case error(String)
}

class ContentViewModel: ObservableObject {
    @Published private(set) var state: ContentState = .idle
    private let repository: ContentRepositoryProtocol
    
    init(repository: ContentRepositoryProtocol) {
        self.repository = repository
    }
    
    @MainActor
    func loadContent() async {
        state = .loading
        
        do {
            let content = try await repository.refreshContent()
            state = .loaded(content)
        } catch {
            handleError(error)
        }
    }
    
    @MainActor
    func refreshContent() async {
        state = .loading
        
        do {
            let content = try await repository.refreshContent()
            state = .loaded(content)
        } catch {
            handleError(error)
        }
    }
    
    private func handleError(_ error: Error) {
        var errorMessage = "An unknown error occurred"
        
        if let networkError = error as? NetworkError {
            switch networkError {
            case .invalidURL:
                errorMessage = "Invalid URL"
            case .invalidResponse:
                errorMessage = "Invalid server response"
            case .dataError:
                errorMessage = "Data error"
            case .decodingError:
                errorMessage = "Could not process the data"
            }
        } else {
            errorMessage = error.localizedDescription
        }
        
        state = .error(errorMessage)
    }
} 
