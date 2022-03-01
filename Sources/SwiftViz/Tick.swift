//
//  Tick.swift
//  SwiftViz
//
//  Created by Joseph Heck on 3/2/20.
//

import CoreGraphics
import Foundation

/// A Tick is a visual representation of a point along an axis.
///
/// When created based on a range, a tick includes a location along a single direction
/// and a textual representation. It is meant to be created using a Scale, with some input domain
/// being mapped to visualization using the Scale's output range.
public protocol Tick: Identifiable {
    // this becomes a generic focused protocol - types implementing it will need to define the
    // protocol conformance in coordination with a generic type
    associatedtype InputType: Comparable

    var id: UUID { get }

    var value: InputType { get }
    var rangeLocation: CGFloat { get }

    init(value: InputType, location: CGFloat)
}
