# Spatial Widget Container for Flutter

This package contains a Container to add spatial properties like rotation and position for widgets in a 3D simulated space. 

![Preview](/files/preview.gif)

![Preview](https://raw.githubusercontent.com/sandboxgb/spatial/main/.github/images/preview.gif)


The container is binded to a SpatialContext (The 3D state of a child widget)

The SpatialContext enable transformation functions like move() or rotate()

## Examples

1\. Declare and construct a spatialContext

```dart

import 'package:spatial/spatial.dart';
import 'package:flutter/material.dart';

final SpatialContext spatialContext = SpatialContext();

```

2\. Add the Spatial Container Widget

```dart

@override
Widget build(BuildContext context) => Spatial(
              child: AnyWidget(),
              spatialContext: spatialContext,
            );

```

3\. Rotate your widget

```dart

void _rotateMyWidget() {
    spatialContext.rotate(x: -1.0);
    spatialContext.rotate(z: 1.5);
}

```

4\. Move your widget

```dart

void _moveMyWidget() {
    spatialContext.move(x: 1.0);
    spatialContext.move(y: -0.5);
}

```
