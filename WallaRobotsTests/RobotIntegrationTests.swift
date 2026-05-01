//
//  RobotIntegrationTests.swift
//  WallaRobots
//
//  Created by Miguel Cabrera on 22/04/2026.
//

import Testing
import Foundation
@testable import WallaRobots

struct RobotIntegrationTests {
    
    @Test("Full user flow: initial load → pagination → search → clear search")
    @MainActor
    func testFullUserFlow_LoadPaginateSearchAndClear() async throws {
        // GIVEN: A viewModel with mocked robots (more than 2 pages worth)
        let mockDataSource = FakeRobotDataSource()
        mockDataSource.result = .success(FakeRobotDataSource.loadMockDTOs())
        let viewModel = RobotViewModel(repository: RobotRepository(dataSource: mockDataSource))
        
        // ============================================
        // STEP 1: Initial Load (first 20 robots)
        // ============================================
        await viewModel.initialLoad()
        
        #expect(viewModel.robots.count == 20, "Initial load should fetch first page (20 robots)")
        #expect(viewModel.currentPage == 1, "Should be on page 1 after initial load")
        #expect(viewModel.hasMoreData, "Should have more data to load")
        
        let firstRobot = try #require(viewModel.robots.first)
        #expect(firstRobot.fullName == "Hadley Eyres", "First robot should be Hadley Eyres")
        
        // ============================================
        // STEP 2: Pagination (load second page)
        // ============================================
        viewModel.loadMoreRobots()
        
        #expect(viewModel.robots.count == 40, "After pagination should have 40 robots")
        #expect(viewModel.currentPage == 2, "Should be on page 2 after pagination")
        
        let robot21 = viewModel.robots[20]
        #expect(robot21.id != firstRobot.id, "Robot at index 20 should be different from first robot")
        
        // ============================================
        // STEP 3: Search for specific robot
        // ============================================
        let searchTerm = "Hadley"
        viewModel.searchText = searchTerm
        viewModel.debouncedSearchText = searchTerm // Simulate View's debounce completion
        
        let filteredResults = viewModel.filteredRobots
        #expect(!filteredResults.isEmpty, "Search should return results")
        #expect(filteredResults.allSatisfy {
            $0.fullName.localizedCaseInsensitiveContains(searchTerm) ||
            $0.username.localizedCaseInsensitiveContains(searchTerm) ||
            $0.email.localizedCaseInsensitiveContains(searchTerm)
        }, "All filtered results should match search term")
        
        #expect(viewModel.robots.count == 40, "Paginated robots should still be 40")
        
        // ============================================
        // STEP 4: Clear search (should restore all paginated robots)
        // ============================================
        viewModel.searchText = ""
        viewModel.debouncedSearchText = ""
        
        #expect(viewModel.filteredRobots.count == 40, "After clearing search, should show all 40 paginated robots")
        #expect(viewModel.currentPage == 2, "Page state should be preserved after search")
    }
    
    // MARK: - Test 2: Multiple Paginations
    
    @Test("User can paginate through all available data")
    @MainActor
    func testMultiplePaginations() async {
        // GIVEN: A viewModel with mocked robots
        let mockDataSource = FakeRobotDataSource()
        mockDataSource.result = .success(FakeRobotDataSource.loadMockDTOs())
        let viewModel = RobotViewModel(repository: RobotRepository(dataSource: mockDataSource))
        
        // WHEN: Load initial and then paginate until no more data
        await viewModel.initialLoad()
        
        var paginationCount = 1
        while viewModel.hasMoreData {
            viewModel.loadMoreRobots()
            paginationCount += 1
            
            if paginationCount > 50 { break }
        }
        
        // THEN: All robots should be loaded
        let totalMockRobots = FakeRobotDataSource.loadMockDTOs().count
        #expect(viewModel.robots.count == totalMockRobots, "Should have loaded all available robots")
        #expect(!viewModel.hasMoreData, "Should have no more data to load")
    }
    
    // MARK: - Test 3: Search persists pagination state
    
    @Test("Search and clear preserves pagination state")
    @MainActor
    func testSearchPreservesPaginationState() async {
        // GIVEN: A viewModel with 2 pages loaded
        let mockDataSource = FakeRobotDataSource()
        mockDataSource.result = .success(FakeRobotDataSource.loadMockDTOs())
        let viewModel = RobotViewModel(repository: RobotRepository(dataSource: mockDataSource))
        
        await viewModel.initialLoad()
        viewModel.loadMoreRobots()
        
        let robotsBeforeSearch = viewModel.robots.count
        let pageBeforeSearch = viewModel.currentPage
        
        // WHEN: Search and then clear
        viewModel.debouncedSearchText = "test"
        _ = viewModel.filteredRobots
        
        viewModel.debouncedSearchText = ""
        
        // THEN: Pagination state should be preserved
        #expect(viewModel.robots.count == robotsBeforeSearch, "Robot count should be preserved")
        #expect(viewModel.currentPage == pageBeforeSearch, "Current page should be preserved")
    }
    
    @Test("Search during loading doesn't break state")
    @MainActor
    func testSearchDuringLoadingMaintainsConsistency() async {
        // GIVEN: A viewModel
        let mockDataSource = FakeRobotDataSource()
        mockDataSource.result = .success(FakeRobotDataSource.loadMockDTOs())
        let viewModel = RobotViewModel(repository: RobotRepository(dataSource: mockDataSource))
        
        // WHEN: Start initial load and immediately search
        await viewModel.initialLoad()
        viewModel.searchText = "Hadley"
        viewModel.debouncedSearchText = "Hadley"
        
        // THEN: State should be consistent
        #expect(!viewModel.robots.isEmpty, "Robots should be loaded")
        #expect(!viewModel.filteredRobots.isEmpty, "Filtered results should exist")
        #expect(viewModel.filteredRobots.allSatisfy {
            $0.fullName.localizedCaseInsensitiveContains("Hadley")
        }, "Filter should work correctly")
    }
    
    @Test("Empty search returns to full list")
    @MainActor
    func testTypingAndDeletingSearchReturnsToFullList() async {
        // GIVEN: A viewModel with loaded robots
        let mockDataSource = FakeRobotDataSource()
        mockDataSource.result = .success(FakeRobotDataSource.loadMockDTOs())
        let viewModel = RobotViewModel(repository: RobotRepository(dataSource: mockDataSource))
        
        await viewModel.initialLoad()
        viewModel.loadMoreRobots()
        
        let totalLoadedRobots = viewModel.robots.count
        
        // WHEN: User types search, then deletes it character by character
        viewModel.debouncedSearchText = "Had"
        #expect(viewModel.filteredRobots.count < totalLoadedRobots, "Should filter results")
        
        viewModel.debouncedSearchText = "Ha"
        viewModel.debouncedSearchText = "H"
        viewModel.debouncedSearchText = ""
        
        // THEN: Should return to showing all loaded robots
        #expect(viewModel.filteredRobots.count == totalLoadedRobots, "Should show all robots after clearing search")
    }
}
