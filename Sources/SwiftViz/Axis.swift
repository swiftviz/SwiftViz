//
//  Axis.swift
//
//  Created by Joseph Heck on 1/2/20.
//

import Foundation

/*
 Axis - a visual representation
 built on a scale
 specific to a dimension (x, y, or z)
 draws the ticks, numbers the line, etc for a side of a chart
 • axisBottom(scale)
 • axisTop(scale)
 • axisLeft(scale)
 • axisRight(scale)
 • axis.ticks(count) passes down to scale.domain...
 • or axis.ticks(d3.timeMinute.every(15)) to create a tick every 15 min
 • ticks have a size - both inner and outer
 often has a margin (spacing) and translation from the side it's attached
 */

public enum AxisDirection {
    case x
    case y
    case z
}

public protocol Axis {
    associatedtype Scale

    var direction: AxisDirection { get }
    // use internalScale.ticks() to determine location for ticks
    // represent them with capsules, or maybe thin "boxes" aligned to the axis?

}
