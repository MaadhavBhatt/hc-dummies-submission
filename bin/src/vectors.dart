import 'dart:math';
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
  
  double magnitude() {
    return sqrt(dot(this));
  }

  void normalize() {
    final mag = magnitude();
    if (mag == 0) {
      throw Exception('Cannot normalize the zero vector.');
    }
    final normalizedComponents =
        components.map((c) => c / mag).toList();
    components.setAll(0, normalizedComponents);
  }

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

bool areOrthogonal(Vector v1, Vector v2) {
  if (v1.dimension != v2.dimension) {
    throw Exception(
      'Vectors must have the same dimension to check orthogonality.',
    );
  }
  return v1.dot(v2) == 0.0;
}

bool areParallel(Vector v1, Vector v2) {
  if (v1.isZeroVector() || v2.isZeroVector()) {
    return true; // Zero vector is parallel to any vector
  }

  if (v1.dimension != v2.dimension) {
    throw Exception(
      'Vectors must have the same dimension to check parallelism.',
    );
  }
  final int dimension = v1.dimension;

  double ratio = v1.components[0] / v2.components[0];
  for (int i = 0; i < dimension; i++) {
    double a = v1.components[i];
    double b = v2.components[i];

    if (a == 0 && b == 0) {
      continue; // Both components are zero, move to next
    } else if (b == 0) {
      return false; // Not parallel if one is zero and the other is not
    } else {
      double currentRatio = a / b;
      if (currentRatio != ratio) {
        return false; // Not parallel if ratios differ
      }
    }
  }
  return true; // All component pairs passed the ratio test
}

/// Validates if a set of vectors can form a basis in their vector space.
///
/// Returns a map with keys:
/// - 'isValid': a boolean indicating if the vectors form a valid basis.
/// - 'reason': a string explaining why the basis is invalid if 'isValid' is
///  false.
///
/// A basis is valid if:
/// - The number of vectors equals the dimension of the vectors.
/// - All vectors have the same dimension.
/// - No vector is the zero vector.
/// - No two vectors are parallel.
///
/// Throws an [Exception] if the set of vectors is empty.
Map<String, dynamic> areValidBasisVectors(Set<Vector> vectors) {
  Map<String, dynamic> response = {'isValid': false, 'reason': ''};
  if (vectors.isEmpty) {
    throw Exception('At least one vector is required to form a basis.');
  }

  final dimension = vectors.first.dimension;

  if (vectors.length != dimension) {
    response['reason'] =
        'Number of vectors must equal the dimension to form a basis.';
    return response;
  }

  for (final v in vectors) {
    if (v.dimension != dimension) {
      response['reason'] = 'All vectors must have the same dimension.';
      return response;
    }
    if (v.isZeroVector()) {
      response['reason'] = 'Vectors cannot be the zero vector.';
      return response;
    }
    if (vectors
        .where((other) => other != v)
        .any((other) => areParallel(v, other))) {
      response['reason'] = 'Vectors must be linearly independent / parallel.';
      return response;
    }
  }
  response['isValid'] = true;
  return response;
}
