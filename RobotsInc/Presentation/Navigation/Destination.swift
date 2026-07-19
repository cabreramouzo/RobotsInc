//
//  Destination.swift
//  RobotsInc
//
//  Created by Miguel Cabrera on 01/05/2026.
//

/// Navigation destinations carry identity, not data: storing an id instead
/// of a full entity keeps the path serializable, avoids stale snapshots and
/// lets deep links build the same destination without loading the list first.
enum Destination: Hashable {
    case detail(robotID: Int)
}
