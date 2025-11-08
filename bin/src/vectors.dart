import 'base.dart';

/// A mathematical vector class representing an n-dimensional vector.
///
/// The [Vector] class extends [MathObject] and provides basic vector operations
/// such as addition and subtraction. This class can be used for both vectors and points
/// in space, depending on the context.
///
/// The class also includes equality and hashCode methods to allow for proper
/// comparison and usage in collections.
///
/// If the vector has fewer than 4 components and is not a subclass, a warning is printed
/// suggesting the use of more specific types like `Vector2D` or `Vector3D`.
///
/// Throws an [Exception] if
/// - the vector has no components.
/// - any component is infinite or NaN.
/// - vector operations are attempted on vectors of different dimensions.
class Vector extends MathObject {
  final List<double> components;
  int get dimension => components.length;

  @override
  String get objectName => 'Vector';
  @override
  Map<String, dynamic> get properties => {'components': components};

  Vector(this.components) {
    if (components.isEmpty) {
      throw Exception('Vector must have at least one component.');
    }
    if (components.any(
      (component) => component.isInfinite || component.isNaN,
    )) {
      throw Exception('Vector components cannot be infinite or NaN.');
    }
    if (dimension < 4 && runtimeType == Vector) {
      print('Warning: Consider using Vector2D or Vector3D for clarity.');
    }
  }

  Vector _elementWiseOp(Vector v, double Function(double, double) op) {
    if (dimension != v.dimension) {
      throw Exception('Vectors must have the same dimension.');
    }
    final result = List<double>.generate(
      dimension,
      (i) => op(components[i], v.components[i]),
    );
    return Vector(result);
  }

  Vector operator +(Vector v) => _elementWiseOp(v, (a, b) => a + b);
  Vector operator -(Vector v) => _elementWiseOp(v, (a, b) => a - b);

  double dot(Vector v) =>
      _elementWiseOp(v, (a, b) => a * b).components.reduce((a, b) => a + b);

  @override
  bool operator ==(Object other) {
    if (other is! Vector || other.dimension != dimension) {
      return false;
    }
    for (int i = 0; i < dimension; i++) {
      if (components[i] != other.components[i]) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode => components.hashCode;

  bool isZeroVector() {
    for (final component in components) {
      if (component != 0.0) {
        return false;
      }
    }
    return true;
  }
}

/// Represents a 2-dimensional vector class extending [Vector].
///
/// Throws an [Exception] if the vector does not have exactly 2 components.
class Vector2D extends Vector {
  @override
  String get objectName => 'Vector2D';

  Vector2D(double x, double y) : super([x, y]) {
    if (dimension != 2) {
      throw Exception('Vector2D must have exactly 2 components.');
    }
  }
}

/// Represents a 2-dimensional vector class extending [Vector].
///
/// Throws an [Exception] if the vector does not have exactly 3 components.
class Vector3D extends Vector {
  @override
  String get objectName => 'Vector3D';

  Vector3D(double x, double y, double z) : super([x, y, z]) {
    if (dimension != 3) {
      throw Exception('Vector3D must have exactly 3 components.');
    }
  }
}
