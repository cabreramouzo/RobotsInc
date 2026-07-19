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

    /// The copy the UI should show for the current error,
    /// or `nil` when there is no error to display.
    var errorViewData: ErrorViewData? {
        error?.viewData
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

    /// Called by the view whenever a row becomes visible. The view model
    /// decides if that means the next page should be loaded: only when
    /// there is no active search and the visible row is the last one.
    @MainActor
    func onRowAppeared(_ robot: Robot) {
        guard searchText.isEmpty, robot.id == filteredRobots.last?.id else { return }
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
