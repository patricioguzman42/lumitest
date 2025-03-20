//
//  ContentListView.swift
//  Lumiform
//
//  Created by Patricio Guzman on 19/03/2025.
//

import SwiftUI

struct ContentListView: View {
    @ObservedObject var viewModel: ContentViewModel
    
    var body: some View {
        NavigationView {
            Group {
                switch viewModel.state {
                case .idle, .loading:
                    LoadingView()
                case .loaded(let items):
                    contentList(items)
                case .error(let message):
                    ErrorView(message: message, retryAction: refreshContent)
                }
            }
            .navigationTitle("Lumiform Content")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: refreshContent) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
        }
        .task {
            await viewModel.loadContent()
        }
    }
    
    private func contentList(_ items: [ContentItem]) -> some View {
        List(items, children: \.items) { item in
            ContentItemView(item: item, nestingLevel: 0)
        }
        .listStyle(.sidebar)
        .refreshable {
            await Task {
                await viewModel.refreshContent()
            }.value
        }
    }
    
    private func refreshContent() {
        Task {
            await viewModel.refreshContent()
        }
    }
}
