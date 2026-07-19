//
//  RobotViewModel.swift
//  RobotsInc
//
//  Created by Miguel Cabrera on 17/04/2026.
//

import SwiftUI
import OSLog

@Observable
final class RobotViewModel {

    // MARK: - Public properties
    var robots: [Robot] = []
    var searchText: String = ""
    var debouncedSearchText: String = ""
    private(set) var isLoading: Bool = false
    private(set) var error: RobotRepositoryError?
    private(set) var currentPage = 0

    // MARK: - Private properties
    private var allRobots: [Robot] = []
    private let repository: RobotRepositoryProtocol
    private let pageSize = 20

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

    /// Maps the domain error into the copy the UI should show.
    /// `nil` when there is no error to display.
    var errorViewData: ErrorViewData? {
        guard let error else { return nil }
        switch error {
        case .network:
            return ErrorViewData(
                title: "No Internet Connection",
                message: "Please check your connection and try again.",
                systemImage: "wifi.slash"
            )
        case .server:
            return ErrorViewData(
                title: "Something Went Wrong",
                message: "Our servers are having a moment. Please try again.",
                systemImage: "exclamationmark.icloud"
            )
        case .unknown:
            return ErrorViewData(
                title: "Unexpected Error",
                message: "An unexpected error occurred. Please try again.",
                systemImage: "exclamationmark.triangle"
            )
        }
    }

    @MainActor
    func initialLoad() async {
        guard allRobots.isEmpty else { return }

        do {
            allRobots = try await repository.fetch()
            error = nil
        } catch {
            self.error = error
            return
        }
        // if no errors, then load more robots
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
