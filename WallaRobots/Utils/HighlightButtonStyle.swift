//
//  HighlightButtonStyle.swift
//  WallaRobots
//

import SwiftUI

struct HighlightButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .listRowBackground(
                configuration.isPressed
                ? Color(.systemGray4)
                : Color(.systemBackground)
            )
    }
}
