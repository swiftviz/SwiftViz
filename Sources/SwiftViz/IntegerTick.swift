////
////  IntegerTick.swift
////  SwiftViz
////
////  Created by Joseph Heck on 3/4/20.
////
//
//import Numerics
//import Foundation
//
//public struct IntegerTick: Tick {
//    public let id = UUID()
//    // making this identifiable as a convenience
//    // for use within SwiftUI. You can then use ForEach over
//    // a sequence of these more cleanly.
//
//    public let value: Int // value from the domain of an associated Scale
//    public let rangeLocation: Float // location maps to the output range of the Scale
//
//    public var stringValue: String {
//        String(format: "%d", value)
//    }
//
//    // public initializer needed in a library, the auto-generated one isn't auto-public
//    public init(value: Int, location: Float) {
//        self.value = value
//        rangeLocation = location
//    }
//}
