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
        if item.isPage || item.isSection {
            HStack(spacing: 8) {
                Text(iconForType)
                Text(item.title)
                    .font(fontForItem)
                    .fontWeight(item.isPage ? .bold : .semibold)
            }
            .padding(.vertical, 4)
        } else if item.isQuestion {
            questionView
        }
    }

    private var questionView: some View {
        VStack(alignment: .leading, spacing: 4) {
            if item.isImageQuestion {
                HStack(spacing: 8) {
                    Text("🖼️")
                    Text(item.title)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
            }
            
            if item.isTextQuestion, let text = item.questionTitle {
                HStack(spacing: 8) {
                    Text("📝")
                    Text(text)
                        .font(.body)
                        .foregroundColor(.primary)
                }
            } else if item.isImageQuestion, let imageURL = item.questionImageURL {
                NavigationLink(destination: ImageDetailView(title: item.title, imageURL: imageURL)) {
                    AsyncImage(url: imageURL) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(height: 120)
                                .frame(maxWidth: .infinity)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 120)
                                .frame(maxWidth: .infinity)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                                .transition(.opacity.animation(.easeInOut(duration: 0.3)))
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 120)
                                .frame(maxWidth: .infinity)
                                .background(Color.gray.opacity(0.1))
                                .foregroundColor(.gray)
                                .cornerRadius(8)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
            }
        }
    }
    
    private var iconForType: String {
        if item.isPage {
            return "📄"
        } else if item.isSection {
            switch nestingLevel {
            case 0: return "📁"
            case 1: return "📂"
            default: return "📑"
            }
        }
        return ""
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
