//
//  DateTick.swift
//  SwiftViz
//
//  Created by Joseph Heck on 3/4/20.
//

import CoreGraphics
import Foundation

public struct DateTick: Tick {
    public let id = UUID()
    // making this identifiable as a convenience
    // for use within SwiftUI. You can then use ForEach over
    // a sequence of these more cleanly.

    public let value: Date
    public let rangeLocation: CGFloat // location maps to the output range of the Scale

    // public initializer needed in a library, the auto-generated one isn't auto-public
    public init(value: Date, location: CGFloat) {
        self.value = value
        rangeLocation = location
    }
}
