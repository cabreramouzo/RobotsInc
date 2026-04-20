//
//  RobotViewModel.swift
//  WallaMarvel
//
//  Created by Miguel Cabrera on 17/04/2026.
//

import SwiftUI
import Combine
import OSLog

final class RobotViewModel: ObservableObject {
    @Published var robots: [Robot] = []

    private var allRobots: [Robot] = []
    var isLoading: Bool = false

    let service: RobotServiceProtocol

    let pageSize = 20
    var currentPage = 0

    @Published var searchText = ""
    @Published var debouncedSearchText = ""

    @Published var showNetworkError: Bool = false

    private var cancellables = Set<AnyCancellable>()

    init(service: RobotServiceProtocol = RobotService()) {
        self.service = service
        setupSearchDebounce()
    }

    func setupSearchDebounce() {
        $searchText
            .debounce(for: .seconds(0.3), scheduler: RunLoop.main)
            .removeDuplicates()
            .assign(to: \.debouncedSearchText, on: self)
            .store(in: &cancellables)

    }

    var filteredRobots: [Robot] {
        if debouncedSearchText.isEmpty {
            return robots
        } else {
            return allRobots.filter {
                $0.fullName.localizedCaseInsensitiveContains(debouncedSearchText) ||
                $0.username.localizedCaseInsensitiveContains(debouncedSearchText) ||
                $0.email.localizedCaseInsensitiveContains(debouncedSearchText)
            }
        }
    }

    var hasMoreData: Bool {
        return debouncedSearchText.isEmpty && currentPage * pageSize < allRobots.count
    }

    @MainActor
    func initialLoad() async {
        guard allRobots.isEmpty else { return }

        do {
            allRobots = try await service.fetchRobots()
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
