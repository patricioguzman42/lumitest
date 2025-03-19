//
//  NetworkService.swift
//  Lumiform
//
//  Created by Patricio Guzman on 19/03/2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case dataError
    case decodingError
}

protocol NetworkServiceProtocol {
    func fetchContent() async throws -> [ContentItem]
}

class NetworkService: NetworkServiceProtocol {
    private let contentURL = URL(string: "https://run.mocky.io/v3/d403fba7-413f-40d8-bec2-afe6ef4e201e")
    
    func fetchContent() async throws -> [ContentItem] {
        guard let url = contentURL else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        do {
            return [try JSONDecoder().decode(ContentItem.self, from: data)]
        } catch {
            throw NetworkError.decodingError
        }
    }
} 
