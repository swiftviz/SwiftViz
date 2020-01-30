import Foundation

// =============================================================
//  Axis.swift

// inspiration: https://github.com/d3/d3-axis
// notes: https://github.com/pshrmn/notes/blob/master/d3/axes.md

// .tickSizeInner()  & .tickSizeOuter() or .tickSize() for both
// .tickFormat()
// .tickPadding()

// .tickValues([...]) - set the specific tick values in by array
// .ticks(5) - set the axis to use 5 ticks (or use an interval of 5 if it's a time scale)
//   optional second argument with the tick formatting
// there should be a scale.ticks() that can be used as a default/proxy for ticks

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

// bottom axis:
// vStack ( line & pips with ticks
//          hstack ( Text(number), Text(number2), Text(number3) )
//         )

