# 🤖 WallaRobots Challenge

This App consist of a robot directory and detail viewer, focused on **high decoupling**, **architectural scalability**, and **optimized SwiftUI performance**.

 | App Icon | Dark Mode | 
 | :--: | :--: |
 | <img src="WallaRobots/Resources/Assets.xcassets/AppIcon.appiconset/WallaRobots-iOS-Default-1024x1024%401x.png" width="150" alt="App Icon"> | <img src="WallaRobots/Resources/Assets.xcassets/AppIcon.appiconset/WallaRobots-iOS-Dark-1024x1024%401x.png" width="150" alt="App Icon"> |

---

## Architecture & Technical Decisions

The app follows **Clean Architecture** principles with **MVVM** in the Presentation layer, organized into three distinct layers:

- **Domain Layer** — Pure Swift entities (`Robot`, `Department`, `Gender`, `RobotStatus`) and repository protocols. No dependencies on other layers.
- **Data Layer** — `RobotDTO`, `RobotRemoteDataSource`, and `RobotRepository` which maps DTOs to domain entities. Only depends on Domain protocols.
- **Presentation Layer** — `RobotViewModel`, SwiftUI Views, and a **Coordinator** pattern for navigation. Only depends on Domain entities and protocols.

Navigation is handled by a `RobotCoordinator` using `NavigationPath` and a typed `Destination` enum, ensuring scalable and decoupled navigation. Views receive dependencies via explicit parameters and closures instead of `@EnvironmentObject`, preserving separation of concerns.

To demonstrate versatility, I used a hybrid image loading strategy: Kingfisher for the main list (leveraging its robust caching) and AsyncImage for the detail view.

Finally, I leveraged Swift 6 concurrency features to ensure thread safety and a responsive UI, along with a debounce strategy to optimize search performance.

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

![SwiftLint](https://github.com/cabreramouzo/WallaRobots/actions/workflows/swiftlint.yml/badge.svg)
![iOS CI](https://github.com/cabreramouzo/WallaRobots/actions/workflows/build_test.yml/badge.svg)

---

## Git Strategy
This project follows a branching model inspired by **Git Flow**.

Configured GIT-LFS to optimize the size of the repository (snapshot images).

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
2. Open `WallaRobots.xcodeproj`.
3. Build and Run. Dependencies (Kingfisher) are managed automatically via Swift Package Manager.
