//
//  ErrorView.swift
//  WallaRobots
//
//  Created by Miguel Cabrera on 20/04/2026.
//

import SwiftUI

struct ErrorViewData {
    let title: String
    let message: String
    let systemImage: String
}

struct ErrorView: View {
    let title: String
    let message: String
    let systemImage: String
    var retry: () async -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: systemImage)
                .font(.system(size: 60))
                .foregroundColor(.gray)

            Text(title)
                .font(.title3)
                .fontWeight(.bold)

            Text(message)
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Button {
                Task { await retry() }
            } label: {
                Text("Retry")
                    .fontWeight(.semibold)
                    .frame(width: 120, height: 40)
                    .background(Color.wallapopColor)
                    .foregroundColor(.white)
                    .cornerRadius(20)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

// MARK: - Previews

#Preview {
    ErrorView(
        title: "No Internet Connection",
        message: "Please check your connection and try again.",
        systemImage: "wifi.slash",
        retry: {}
    )
}
