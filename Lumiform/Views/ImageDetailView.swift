//
//  ImageDetailView.swift
//  Lumiform
//
//  Created by Patricio Guzman on 19/03/2025.
//

import SwiftUI

struct ImageDetailView: View {
    let title: String
    let imageURL: URL
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .padding()
            
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .failure:
                    VStack {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                        Text("Failed to load image")
                    }
                @unknown default:
                    EmptyView()
                }
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle("Image Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        ImageDetailView(
            title: "Sample Image",
            imageURL: URL(string: "https://robohash.org/280?&set=set4&size=400x400")!
        )
    }
}
