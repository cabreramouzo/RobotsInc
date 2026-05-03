//
//  RobotViewModel.swift
//  WallaMarvel
//
//  Created by Miguel Cabrera on 17/04/2026.
//

import SwiftUI
import OSLog

@Observable
final class RobotViewModel {
    var robots: [Robot] = []

    private var allRobots: [Robot] = []
    private(set) var isLoading: Bool = false

    private let repository: RobotRepositoryProtocol

    private let pageSize = 20
    private(set) var currentPage = 0

    var searchText: String = ""
    var debouncedSearchText: String = ""

    private(set) var showNetworkError: Bool = false

    init(repository: RobotRepositoryProtocol) {
        self.repository = repository
    }

    var filteredRobots: [Robot] {
        if debouncedSearchText.isEmpty { return robots }

        return allRobots.filter {
            $0.fullName.localizedCaseInsensitiveContains(debouncedSearchText) ||
            $0.username.localizedCaseInsensitiveContains(debouncedSearchText) ||
            $0.email.localizedCaseInsensitiveContains(debouncedSearchText)
        }
    }

    var hasMoreData: Bool {
        return debouncedSearchText.isEmpty && currentPage * pageSize < allRobots.count
    }

    @MainActor
    func initialLoad() async {
        guard allRobots.isEmpty else { return }

        do {
            allRobots = try await repository.fetch()
        } catch let urlError as URLError {
            if urlError.code == .notConnectedToInternet || urlError.code == .timedOut {
                self.showNetworkError = true
            }
            Logger.network.error("Network error: \(urlError.localizedDescription)")
        } catch {
            Logger.network.error("Unexpected error fetching robots: \(error.localizedDescription)")
        }

        loadMoreRobots()
    }

    @MainActor
    func loadMoreRobots() {
        guard !isLoading && hasMoreData else { return }

        isLoading = true

        let start = currentPage * pageSize
        let end = min(start + pageSize, allRobots.count)

        guard start < end else { return }

        let newSlice = allRobots[start..<end]
        robots.append(contentsOf: newSlice)

        currentPage += 1
        isLoading = false
    }
}
