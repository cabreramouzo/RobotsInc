//
//  RobotRepositoryError+Presentation.swift
//  RobotsInc
//
//  Created by Miguel Cabrera on 19/07/2026.
//

/// Maps each domain error to the copy the UI should show.
/// Lives in Presentation so the domain stays free of display concerns,
/// and is shared by every view model that surfaces repository errors.
extension RobotRepositoryError {
    var viewData: ErrorViewData {
        switch self {
        case .network:
            ErrorViewData(
                title: "No Internet Connection",
                message: "Please check your connection and try again.",
                systemImage: "wifi.slash"
            )
        case .server:
            ErrorViewData(
                title: "Something Went Wrong",
                message: "Our servers are having a moment. Please try again.",
                systemImage: "exclamationmark.icloud"
            )
        case .notFound:
            ErrorViewData(
                title: "Robot Not Found",
                message: "We couldn't find that robot. It may no longer be available.",
                systemImage: "questionmark.circle"
            )
        case .unknown:
            ErrorViewData(
                title: "Unexpected Error",
                message: "An unexpected error occurred. Please try again.",
                systemImage: "exclamationmark.triangle"
            )
        }
    }
}
