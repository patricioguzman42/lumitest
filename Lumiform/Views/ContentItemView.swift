//
//  ContentItemView.swift
//  Lumiform
//
//  Created by Patricio Guzman on 19/03/2025.
//

import SwiftUI

struct ContentItemView: View {
    let item: ContentItem
    let nestingLevel: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if item.isPage || item.isSection {
                headerView
                
                if let items = item.items, !items.isEmpty {
                    ForEach(items) { subItem in
                        ContentItemView(item: subItem, nestingLevel: nestingLevel + 1)
                            .padding(.leading, 16)
                    }
                }
            } else if item.isQuestion {
                questionView
            }
        }
    }
    
    private var headerView: some View {
        Text(item.title)
            .font(fontForItem)
            .fontWeight(item.isPage ? .bold : .semibold)
            .padding(.vertical, 4)
    }
    
    private var questionView: some View {
        VStack(alignment: .leading, spacing: 4) {
            if item.isImageQuestion {
                Text(item.title)
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
            
            if item.isTextQuestion, let text = item.questionTitle {
                Text(text)
                    .font(.body)
                    .foregroundColor(.primary)
            } else if item.isImageQuestion, let imageURL = item.questionImageURL {
                NavigationLink(destination: ImageDetailView(title: item.title, imageURL: imageURL)) {
                    AsyncImage(url: imageURL) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 120)
                                .cornerRadius(8)
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 120)
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
            }
        }
    }
    
    private var fontForItem: Font {
        if item.isPage {
            return .title
        } else if item.isSection {
            // Reduce font size based on nesting level
            switch nestingLevel {
            case 0:
                return .title2
            case 1:
                return .title3
            case 2:
                return .headline
            default:
                return .subheadline
            }
        } else {
            return .body
        }
    }
}
