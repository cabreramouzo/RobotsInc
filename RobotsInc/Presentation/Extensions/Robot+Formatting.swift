//
//  Robot+Formatting.swift
//  RobotsInc
//
//  Created by Miguel Cabrera on 18/07/2026.
//

import Foundation

extension Robot {
    /// Price formatted as EUR currency, respecting the user's locale
    /// (e.g. "1.024,50 €" in es_ES, "€1,024.50" in en_US).
    var formattedPrice: String {
        price.formatted(.currency(code: "EUR"))
    }
}
