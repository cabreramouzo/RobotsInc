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

    private var allRobots: [Robot] = []
    var isLoading: Bool = false

    let pageSize = 20
    var currentPage = 0

    var hasMoreData: Bool {
        return currentPage * pageSize < allRobots.count
    }

    @MainActor
    func initialLoad() async throws {

        let urlString = "https://acoding.academy/testData/EmpleadosData.json"
        guard let url = URL(string: urlString) else { return }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            let decodedRobots = try JSONDecoder().decode([Robot].self, from: data)

            allRobots = decodedRobots
            try? await loadMoreRobots()

        } catch {
            print("Error fetching robots: \(error)")
        }

    }

    @MainActor
    func loadMoreRobots() async throws {

        guard !isLoading && hasMoreData else { return }

        isLoading = true

        try? await Task.sleep(nanoseconds: 50_000_000)

        let start = currentPage * pageSize
        let end = min(start + pageSize, allRobots.count)

        guard start < end else { return }

        let newSlice = allRobots[start..<end]
        robots.append(contentsOf: newSlice)

        currentPage += 1

        try? await Task.sleep(nanoseconds: 200_000_000)
        isLoading = false



    }
}

