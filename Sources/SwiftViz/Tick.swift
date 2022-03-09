//
//  Tick.swift
//  SwiftViz
//
//  Created by Joseph Heck on 3/2/20.
//

import Foundation
import Numerics

/// A  visual representation of a point along an axis.
///
/// When created based on a range, a tick includes a location along a single direction
/// and a textual representation. It is meant to be created using a Scale, with some input domain
/// being mapped to visualization using the Scale's output range.
public struct Tick<InputType, OutputType: Real>: Identifiable {
    // this becomes a generic focused protocol - types implementing it will need to define the
    // protocol conformance in coordination with a generic type
    public var id: UUID = .init()

    let value: InputType
    let rangeLocation: OutputType

    init?(value: InputType, location: OutputType) {
        self.value = value
        if location.isNaN {
            return nil
        } else {
            rangeLocation = location
        }
    }
}
