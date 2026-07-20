# 🤖 RobotsInc Challenge

This App consist of a robot directory and detail viewer, focused on **high decoupling**, **architectural scalability**, and **optimized SwiftUI performance**.

 | App Icon | Dark Mode | 
 | :--: | :--: |
 | <img src="RobotsInc/Resources/Assets.xcassets/AppIcon.appiconset/RobotsInc-iOS-Default-1024x1024%401x.png" width="150" alt="App Icon"> | <img src="RobotsInc/Resources/Assets.xcassets/AppIcon.appiconset/RobotsInc-iOS-Dark-1024x1024%401x.png" width="150" alt="App Icon"> |

---

## Architecture & Technical Decisions

The app follows **Clean Architecture** principles with **MVVM** in the Presentation layer, organized into three distinct layers:

- **Domain Layer** — Pure Swift entities (`Robot`, `Department`, `Gender`, `RobotStatus`) and repository protocols. No dependencies on other layers.
- **Data Layer** — `RobotDTO`, `RobotRemoteDataSource`, and `RobotRepository` which maps DTOs to domain entities. Only depends on Domain protocols.
- **Presentation Layer** — `RobotViewModel`, SwiftUI Views, and a **Coordinator** pattern for navigation. Only depends on Domain entities and protocols.

Navigation is handled by an `AppCoordinator` that owns the root `NavigationPath` and a typed `Destination` enum. Destinations carry **identity, not entities** (`Destination.detail(robotID:)`): the detail screen resolves its robot by id through the repository. This keeps the path serializable, avoids stale snapshots, and lets deep links (`robotsinc://robot/<id>`) open any screen — even on a cold start — reusing the exact same navigation route as a tap in the list. Views receive dependencies via explicit parameters and closures instead of `@EnvironmentObject`, preserving separation of concerns and testability.

**Error handling** mirrors the data flow: each layer translates failures into a vocabulary it owns instead of leaking transport types upwards. `RobotRemoteDataSource` maps `URLError`, non-200 responses and decoding failures into a semantic `RobotDataSourceError`; `RobotRepository` maps those into a domain-facing `RobotRepositoryError`; and the ViewModel turns that into user-facing copy (`ErrorViewData`) consumed by a generic `ErrorView`. Swift 6 **typed throws** (`throws(RobotRepositoryError)`) make the error contract explicit and the `switch` exhaustive at every boundary. This is deliberately more structure than a single-source app needs — I kept it to illustrate the boundary discipline that starts paying off once caching, multiple data sources or retry policies multiply the error space.

To demonstrate versatility, I used a hybrid image loading strategy: Kingfisher for the main list (leveraging its robust caching) and AsyncImage for the detail view.

Finally, I leveraged Swift 6 concurrency features to ensure thread safety and a responsive UI, along with a debounce strategy to optimize search performance.

> **A note on pagination:** pagination is currently **client-side** — `fetch()` downloads the full dataset once and the ViewModel serves it in local slices of 20. This keeps the demo self-contained, but it doesn't scale: at large datasets the first bottleneck is the initial fetch and decode, not the UI. The real fix starts at the contract (`fetch(page:pageSize:)` on the repository, with server-side paging), which the current layering keeps as a localized change.

---

## Testing
* **Unit Testing (Swift Testing & XCTest):** Focused on ViewModel logic, validating initial load, filtering, and pagination behavior.
* **Integration (Swift Testing):** Focused on the entire ViewModel state, when performing several actions simulating the user interaction including debouncing when searching and pagination.
* **UI Testing (XCUITest):** Integration tests to ensure navigation flow between list and detail views and data consistency.
* **Snapshot Testing:** Using swift-snapshot-testing by [Pointfree](https://github.com/pointfreeco/swift-snapshot-testing) to test some screens using snapshots.

---

## Continuous Integration (CI/CD)

Automated workflows via **GitHub Actions** ensure project stability on every `Pull Request` and `push` to master:

* **SwiftLint Workflow:** Automated code style analysis to ensure contributions adhere to defined best practices and maintain a clean, uniform codebase.
* **Unit & UI Testing Workflow:** Automated test execution on macOS 26 with Xcode 26.3. The workflow builds and runs tests on an iPhone 17 simulator, blocking merges if any test fails.

![SwiftLint](https://github.com/cabreramouzo/RobotsInc/actions/workflows/swiftlint.yml/badge.svg)
![iOS CI](https://github.com/cabreramouzo/RobotsInc/actions/workflows/build_test.yml/badge.svg)

---

## Git Strategy
This project follows a branching model inspired by **Git Flow**.

*Branches have been intentionally preserved to showcase the incremental development process.*

---

## Credits & Data Sources
* **Icon Design:** Custom app icon created using Apple [Icon Composer](https://developer.apple.com/icon-composer/).
* **Image API:** Using [Robohash](https://robohash.org/) for dynamic robot avatar generation.
* **Data Source:** Due to the original Marvel API's unavailability, a remote endpoint with a dummy employee dataset from previous training stages was used.
* **CI/CD Tooling:** [SwiftLint Action](https://github.com/marketplace/actions/github-action-for-swiftlint) (based on the work by **norio-nomura**), used to automate code style enforcement.

---

## 📱 Screenshots
| List View | Detail View | Search | Offline View |
| :---: | :---: | :---: |  :---: |
| <img src="Screenshots/RobotList.png" width="200" alt="Robot list"> | <img src="Screenshots/RobotDetail.png" width="200" alt="Robot Detail"> | <img src="Screenshots/Search.png" width="200" alt="Search view"> | <img src="Screenshots/NoInternet.png" width="200" alt="No Internet view"> |

---

## Future improvements
* **Localization:** Implementing localization support to make the app accessible to a wider audience.
* **Offline Support (Persistence):** Implementing a more robust offline mode with better error handling and user feedback, persist data using SwiftData.
* **Analytics & Observability:** Integrating analytics to track user interactions and identify areas for improvement.
* **Search Enhancements:** Implementing advanced search features such as filtering by robot attributes or sorting options.
* **CI snapshots:** Adding snapshot testing to the CI workflow to catch UI regressions early. I didn't have time to make it work.
* **Modularization:** The project could be split into SPM modules to enforce layer boundaries at compile time:
    - **DomainModule**: Entities and Repository protocols (no dependencies)
    - **DataModule**: DTOs, DataSources, Repository implementations (imports DomainModule)  
    - **PresentationModule**: ViewModels and Views (imports DomainModule only)

    This would make it impossible for Presentation to accidentally access Data layer internals like `RobotDTO`.

---

## Requirements & Setup
* **iOS:** 17.0+
* **Swift:** 6.0 (Strict Concurrency compatible)
* **Xcode Previews:** The `test_robots.json` file is included in the App's **Target Membership** to ensure Previews work correctly with mock data.

---

### Installation
1. Clone the repository.
2. Open `RobotsInc.xcodeproj`.
3. Build and Run. Dependencies (Kingfisher) are managed automatically via Swift Package Manager.
