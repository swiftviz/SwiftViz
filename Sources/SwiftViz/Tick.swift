//
//  Tick.swift
//  SwiftViz
//
//  Created by Joseph Heck on 3/2/20.
//

import Foundation

/// A Tick is a visual representation of a point along an axis.
/// When created based on a range, it includes a location along a single direction
/// and a textual representation. It is meant to be created using a Scale, with some input domain
/// being mapped to visualization using the Scale's output range.
public struct Tick: Identifiable {

    public let id = UUID()
    // making this identifiable as a convenience
    // for use within SwiftUI. You can then use ForEach over
    // a sequence of these more cleanly.

    public let value: CGFloat // value from the domain of an associated Scale
    public let location: CGFloat // location may be different from value - possibly a computed offset

    public var stringValue: String {
        String(format: "%.1f", value)
    }

    // public initializer needed in a library, the auto-generated one isn't auto-public
    public init(value: CGFloat, location: CGFloat) {
        self.value = value
        self.location = location
    }
}
