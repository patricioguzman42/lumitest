//
//  LoadingView.swift
//  Lumiform
//
//  Created by Patricio Guzman on 19/03/2025.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            Spacer()
            ProgressView()
                .controlSize(.large)
            Text("Loading content...")
                .font(.headline)
                .padding()
            Spacer()
        }
    }
}
