//
//  RobotViewModel.swift
//  WallaMarvel
//
//  Created by Miguel Cabrera on 17/04/2026.
//

import SwiftUI
import Combine

final class RobotViewModel: ObservableObject {
    @Published var robots: [Robot] = []

    @MainActor
    func fetchRobots() async throws {

        let urlString = "https://acoding.academy/testData/EmpleadosData.json"
        guard let url = URL(string: urlString) else { return }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            let decodedRobots = try JSONDecoder().decode([Robot].self, from: data)

            robots = decodedRobots

        } catch {
            print("Error fetching robots: \(error)")
        }
    }
}

