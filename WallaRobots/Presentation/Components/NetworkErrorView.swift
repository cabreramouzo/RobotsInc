//
//  NetworkErrorView.swift
//  WallaRobots
//
//  Created by Miguel Cabrera on 20/04/2026.
//

import SwiftUI

struct NetworkErrorView: View {
    var action: () async -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "wifi.slash")
                .font(.system(size: 60))
                .foregroundColor(.gray)

            Text("No Internet Connection")
                .font(.title3)
                .fontWeight(.bold)

            Text("Please check your connection and try again.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Button {
                Task { await action() }
            } label: {
                Text("Retry")
                    .fontWeight(.semibold)
                    .frame(width: 120, height: 40)
                    .background(Color(red: 0.07, green: 0.76, blue: 0.67))
                    .foregroundColor(.white)
                    .cornerRadius(20)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}
