//
//  LumiformApp.swift
//  Lumiform
//
//  Created by Patricio Guzman on 19/03/2025.
//

import SwiftUI

@main
struct LumiformApp: App {
    @StateObject var contentViewModel: ContentViewModel
    
    init() {
        let networkService = NetworkService()
        let cacheService = CacheService()
        let reachabilityService = ReachabilityService()
        let repository = ContentRepository(
            networkService: networkService,
            cacheService: cacheService,
            reachabilityService: reachabilityService
        )
        _contentViewModel = StateObject(wrappedValue: ContentViewModel(repository: repository))
    }
    
    var body: some Scene {
        WindowGroup {
            ContentListView(viewModel: contentViewModel)
        }
    }
}
