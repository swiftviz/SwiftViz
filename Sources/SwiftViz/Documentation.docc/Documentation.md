# ``SwiftViz``

A collection of components to provide structures that support data visualization.

## Overview

SwiftViz includes components useful to creating visualizations of data.
Many such visualizations require mapping from an abstract set of input values to another output value.
The ``SwiftViz/Scale`` protocol defines the common set of functions required. 
Concrete scales that map linearly and logrithmicly are provided, with convenience methods to create them on the enumerations that host the collections mapping to different underlying types.

Loosely based on the APIs and the visualization constructs created by Mike Bostock and contributors to [D3.js](https://d3js.org)

## Topics

### Scales

- ``SwiftViz/Scale``
- ``SwiftViz/TickScale``
- ``SwiftViz/NiceValue``
- ``SwiftViz/LinearScale``
- ``SwiftViz/LogScale``
- ``SwiftViz/PowerScale``

### Axis

- ``SwiftViz/AxisDimension``
- ``SwiftViz/ChartOrientation``
- ``Tick``
