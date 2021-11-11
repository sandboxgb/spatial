library spatial;

import 'package:flutter/cupertino.dart';

abstract class TransformFactors {
  double get rotationFactor;
  double get scaleFactor;
  double get moveFactor;

  @override
  String toString() {
    return 'TransformFactors{moveFactor=$moveFactor, rotationFactor=$rotationFactor, scaleFactor=$scaleFactor}';
  }
}

class DefaultTransformFactors implements TransformFactors {
  @override
  double get moveFactor => 5.0;

  @override
  double get rotationFactor => 0.07;

  @override
  double get scaleFactor => 0.04;

  const DefaultTransformFactors();

  @override
  String toString() {
    return 'DefaultTransformFactors{moveFactor=$moveFactor, rotationFactor=$rotationFactor, scaleFactor=$scaleFactor}';
  }
}

class Offset3D extends Offset {
  final double dz;
  const Offset3D(double dx, double dy, this.dz) : super(dx, dy);

  Offset3D copy({double? x, double? y, double? z}) =>
      Offset3D(x ?? dx, y ?? dy, z ?? dz);

  static Offset3D get zero => const Offset3D(0.0, 0.0, 0.0);

  /// Unary negation operator.
  ///
  /// Returns an offset with the coordinates negated.
  ///
  /// If the [Offset] represents an arrow on a plane, this operator returns the
  /// same arrow but pointing in the reverse direction.
  @override
  Offset3D operator -() => Offset3D(-dx, -dy, -dz);

  /// Binary subtraction operator.
  ///
  /// Returns an offset whose [dx] value is the left-hand-side operand's [dx]
  /// minus the right-hand-side operand's [dx] and whose [dy] value is the
  /// left-hand-side operand's [dy] minus the right-hand-side operand's [dy].
  ///
  /// See also [translate].
  @override
  Offset3D operator -(Offset other) => Offset3D(
      dx - other.dx, dy - other.dy, other is Offset3D ? dz - other.dz : dz);

  /// Binary addition operator.
  ///
  /// Returns an offset whose [dx] value is the sum of the [dx] values of the
  /// two operands, and whose [dy] value is the sum of the [dy] values of the
  /// two operands.
  ///
  /// See also [translate].
  @override
  Offset3D operator +(Offset other) => Offset3D(
      dx + other.dx, dy + other.dy, other is Offset3D ? dz + other.dz : dz);

  /// Multiplication operator.
  ///
  /// Returns an offset whose coordinates are the coordinates of the
  /// left-hand-side operand (an Offset) multiplied by the scalar
  /// right-hand-side operand (a double).
  ///
  /// See also [scale].
  @override
  Offset3D operator *(double operand) =>
      Offset3D(dx * operand, dy * operand, dz * operand);

  /// Division operator.
  ///
  /// Returns an offset whose coordinates are the coordinates of the
  /// left-hand-side operand (an Offset) divided by the scalar right-hand-side
  /// operand (a double).
  ///
  /// See also [scale].
  @override
  Offset3D operator /(double operand) =>
      Offset3D(dx / operand, dy / operand, dz / operand);

  /// Integer (truncating) division operator.
  ///
  /// Returns an offset whose coordinates are the coordinates of the
  /// left-hand-side operand (an Offset) divided by the scalar right-hand-side
  /// operand (a double), rounded towards zero.
  @override
  Offset3D operator ~/(double operand) => Offset3D((dx ~/ operand).toDouble(),
      (dy ~/ operand).toDouble(), (dz ~/ operand).toDouble());

  /// Modulo (remainder) operator.
  ///
  /// Returns an offset whose coordinates are the remainder of dividing the
  /// coordinates of the left-hand-side operand (an Offset) by the scalar
  /// right-hand-side operand (a double).
  @override
  Offset3D operator %(double operand) =>
      Offset3D(dx % operand, dy % operand, dz % operand);

  @override
  String toString() {
    return 'Offset3D{dx: $dx, dy: $dy, dz: $dz}';
  }
}

class SpatialContext {
  final TransformFactors transformFactors;
  Offset3D _rotationOffset = const Offset3D(0.0, 0.0, 0.0);
  Offset3D _positionOffset = const Offset3D(0.0, 0.0, 0.5);

  Offset3D get rotationOffset => _rotationOffset;
  set rotationOffset(Offset3D value) {
    _rotationOffset = value;
    _updateState();
  }

  Offset3D get positionOffset => _positionOffset;
  set positionOffset(Offset3D value) {
    _positionOffset = value;
    _updateState();
  }

  _SpatialState? parentState;
  void Function()? onUpdate;

  SpatialContext({this.transformFactors = const DefaultTransformFactors()});

  void move({double? x, double? y, double? z}) {
    if (x != null) {
      positionOffset = positionOffset.copy(
          x: positionOffset.dx + (x * transformFactors.moveFactor));
    }
    if (y != null) {
      positionOffset = positionOffset.copy(
          y: positionOffset.dy + (y * transformFactors.moveFactor));
    }
    if (z != null) {
      positionOffset = positionOffset.copy(
          z: positionOffset.dz + ((z * -1) * transformFactors.scaleFactor));
    }
    _updateState();
  }

  void moveTo({double? x, double? y, double? z}) {
    if (x != null) {
      positionOffset =
          positionOffset.copy(x: (x * transformFactors.moveFactor));
    }
    if (y != null) {
      positionOffset =
          positionOffset.copy(y: (y * transformFactors.moveFactor));
    }
    if (z != null) {
      positionOffset =
          positionOffset.copy(z: ((z * -1) * transformFactors.scaleFactor));
    }
    _updateState();
  }

  void rotate({double? x, double? y, double? z}) {
    if (x != null) {
      rotationOffset = rotationOffset.copy(
          x: rotationOffset.dx + (x * transformFactors.rotationFactor));
    }
    if (y != null) {
      rotationOffset = rotationOffset.copy(
          y: rotationOffset.dy + (y * transformFactors.rotationFactor));
    }
    if (z != null) {
      rotationOffset = rotationOffset.copy(
          z: rotationOffset.dz + (z * transformFactors.rotationFactor));
    }
    _updateState();
  }

  void rotateTo({double? x, double? y, double? z}) {
    if (x != null) {
      rotationOffset =
          rotationOffset.copy(x: (x * transformFactors.rotationFactor));
    }
    if (y != null) {
      rotationOffset =
          rotationOffset.copy(y: (y * transformFactors.rotationFactor));
    }
    if (z != null) {
      rotationOffset =
          rotationOffset.copy(z: (z * transformFactors.rotationFactor));
    }
    _updateState();
  }

  void _updateState() {
    onUpdate?.call();
    parentState?.setState(() {});
  }

  @override
  String toString() {
    return 'SpatialContext{rotationOffset: $rotationOffset, positionOffset: $positionOffset}';
  }
}

class Spatial extends StatefulWidget {
  final SpatialContext spatialContext;
  final Widget child;
  const Spatial({Key? key, required this.spatialContext, required this.child})
      : super(key: key);

  @override
  _SpatialState createState() => _SpatialState();
}

class _SpatialState extends State<Spatial> {
  @override
  void didChangeDependencies() {
    widget.spatialContext.parentState = this;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) => Transform(
        // Transform widget
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001) // perspective
          ..rotateX(widget.spatialContext.rotationOffset.dx)
          ..rotateY(widget.spatialContext.rotationOffset.dy)
          ..rotateZ(widget.spatialContext.rotationOffset.dz),
        alignment: FractionalOffset.center,
        child: Transform.scale(
            scale: widget.spatialContext.positionOffset.dz,
            child: Transform.translate(
              offset: Offset(widget.spatialContext.positionOffset.dx,
                  widget.spatialContext.positionOffset.dy),
              child: widget.child,
            )),
      );
}
