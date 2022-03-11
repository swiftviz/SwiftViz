import Foundation

// =============================================================
//  Axis.swift
// NOTE: migrate to where we do the UI specific pieces, as this matches
// more with the UI display, not the underlying concepts

// inspiration: https://github.com/d3/d3-axis
// notes: https://github.com/pshrmn/notes/blob/master/d3/axes.md

// .tickSizeInner()  & .tickSizeOuter() or .tickSize() for both
// .tickFormat()
// .tickPadding()

// .tickValues([...]) - set the specific tick values in by array
// .ticks(5) - set the axis to use 5 ticks (or use an interval of 5 if it's a time scale)
//   optional second argument with the tick formatting
// there should be a scale.ticks() that can be used as a default/proxy for ticks

/// The face or edge a chart visualization.
public enum ChartOrientation {
    /// The leading edge or face of a chart based on the locale's RTL setting.
    ///
    /// This translates to the left edge or face for locales that read right-to-left.
    case leading
    /// The trailing edge or face of a chart based on the locale's RTL setting.
    ///
    /// This translates to the right edge or face for locales that read right-to-left.
    case trailing
    /// The upper edgeor face of a chart.
    case upper
    /// The lower edge or face of a chart.
    case lower
    /// The face of a chart closest to the viewer.
    case foreground
    /// The face of the chart farthest from the view.
    case background
}

/// The identifier for a dimension the chart visualizes.
public enum AxisDimension {
    /// The `x` axis, often displayed horizontally.
    case x
    /// The `y` axis, often displayed vertically.
    case y
    /// The `z` axis, often displayed foreground to background.
    case z
}

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

// public enum AxisDirection {
//    case x
//    case y
//    case z
// }
//
// public protocol Axis {
//    associatedtype Scale
//
//    var direction: AxisDirection { get }
//    // use internalScale.ticks() to determine location for ticks
//    // represent them with capsules, or maybe thin "boxes" aligned to the axis?
// }

// bottom axis:
// vStack ( line & pips with ticks
//          hstack ( Text(number), Text(number2), Text(number3) )
//         )
