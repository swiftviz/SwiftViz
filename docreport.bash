#!/bin/bash

set -e  # exit on a non-zero return code from a command
set -x  # print a trace of commands as they execute

rm -rf .build
mkdir -p .build/symbol-graphs

$(xcrun --find swift) build --target SwiftViz \
    -Xswiftc -emit-symbol-graph \
    -Xswiftc -emit-symbol-graph-dir -Xswiftc .build/symbol-graphs

$(xcrun --find docc) convert Sources/SwiftViz/Documentation.docc \
    --analyze \
    --fallback-display-name SwiftViz \
    --fallback-bundle-identifier com.github.swiftviz.SwiftViz \
    --fallback-bundle-version 0.1.9 \
    --additional-symbol-graph-dir .build/symbol-graphs \
    --experimental-documentation-coverage \
    --level brief
