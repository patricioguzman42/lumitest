//
//  ErrorView.swift
//  Lumiform
//
//  Created by Patricio Guzman on 19/03/2025.
//

import SwiftUI

struct ErrorView: View {
    let message: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.red)
            
            Text("Error")
                .font(.title)
            
            Text(message)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Retry") {
                retryAction()
            }
            .buttonStyle(.borderedProminent)
            .padding()
            
            Spacer()
        }
    }
}

