import 'base.dart';

class Vector extends MathObject {
  final List<double> components;

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
    if (components.length < 4 && runtimeType == Vector) {
      print('Warning: Consider using Vector2D or Vector3D for clarity.');
    }
  }

  Vector _elementWiseOp(Vector v, double Function(double, double) op) {
    if (components.length != v.components.length) {
      throw Exception('Vectors must have the same dimension.');
    }
    final result = List<double>.generate(
      components.length,
      (i) => op(components[i], v.components[i]),
    );
    return Vector(result);
  }

  Vector operator +(Vector v) => _elementWiseOp(v, (a, b) => a + b);
  Vector operator -(Vector v) => _elementWiseOp(v, (a, b) => a - b);

  @override
  bool operator ==(Object other) {
    if (other is! Vector || other.components.length != components.length) {
      return false;
    }
    for (int i = 0; i < components.length; i++) {
      if (components[i] != other.components[i]) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode => components.hashCode;
}

class Vector2D extends Vector {
  @override
  String get objectName => 'Vector2D';

  Vector2D(double x, double y) : super([x, y]) {
    if (components.length != 2) {
      throw Exception('Vector2D must have exactly 2 components.');
    }
  }
}

class Vector3D extends Vector {
  @override
  String get objectName => 'Vector3D';

  Vector3D(double x, double y, double z) : super([x, y, z]) {
    if (components.length != 3) {
      throw Exception('Vector3D must have exactly 3 components.');
    }
  }
}
