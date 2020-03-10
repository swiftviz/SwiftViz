//
//  DateTick.swift
//  SwiftViz
//
//  Created by Joseph Heck on 3/4/20.
//

import CoreGraphics
import Foundation

@available(OSX 10.12, iOS 10.0, watchOS 3.0, *)
public struct DateTick: Tick {
    public typealias InputType = Date

    public let id = UUID()
    // making this identifiable as a convenience
    // for use within SwiftUI. You can then use ForEach over
    // a sequence of these more cleanly.

    public let value: Date
    public let rangeLocation: CGFloat // location maps to the output range of the Scale

    private let fm = ISO8601DateFormatter()
    public var stringValue: String {
        fm.string(from: value)
    }

    // public initializer needed in a library, the auto-generated one isn't auto-public
    public init(value: Date, location: CGFloat) {
        self.value = value
        rangeLocation = location
    }
}
