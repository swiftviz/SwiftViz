//
//  Tick.swift
//  SwiftViz
//
//  Created by Joseph Heck on 3/2/20.
//

import Foundation

public struct Tick: Identifiable {
    public let id = UUID() // making this identifiable for convenience
    // of use within SwiftUI - you can then use ForEach a touch
    // more cleanly...

    public let value: CGFloat // value from the domain of an associated Scale
    public let location: CGFloat // location may be different from value - possibly a computed offset

    public var stringValue: String {
        String(format: "%.0f", value)
    }

    // public initializer needed in a library, the auto-generated one isn't auto-public
    public init(value: CGFloat, location: CGFloat) {
        self.value = value
        self.location = location
    }
}
