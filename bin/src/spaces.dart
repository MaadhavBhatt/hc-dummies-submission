import 'base.dart';
import 'vectors.dart';

class Line extends MathObject {
  @override
  String get objectName => 'Line';
  @override
  Map<String, dynamic> get properties => {};
}

class TwoDLine extends Line {
  final double slope;
  final double intercept;

  @override
  String get objectName => 'TwoDLine';
  @override
  Map<String, dynamic> get properties => {
    'slope': slope,
    'intercept': intercept,
  };

  TwoDLine(this.slope, this.intercept) {
    if (slope.isInfinite) {
      throw Exception('Slope cannot be infinite for a 2D line.');
    }
    if (intercept.isInfinite) {
      throw Exception('Intercept cannot be infinite for a 2D line.');
    }
  }

  double getSlope() {
    return slope;
  }

  double getIntercept() {
    return intercept;
  }

  static TwoDLine fromTwoPoints(Vector2D p1, Vector2D p2) {
    if (p1 == p2) {
      throw Exception("Points must be distinct to define a line.");
    }

    double slope = (p2.y - p1.y) / (p2.x - p1.x);
    double intercept = p1.y - slope * p1.x;
    return TwoDLine(slope, intercept);
  }
}

class ThreeDLine extends Line {
  final Vector3D point; // A point on the line [x, y, z]
  final Vector3D direction; // Direction vector of the line [dx, dy, dz]

  @override
  String get objectName => 'ThreeDLine';
  @override
  Map<String, Vector3D> get properties => {
    'point': point,
    'direction': direction,
  };

  ThreeDLine(this.point, this.direction) {
    if (direction.isZeroVector()) {
      throw Exception('Direction vector cannot be the zero vector.');
    }
  }

  Vector3D getPoint() {
    return point;
  }

  Vector3D getDirection() {
    return direction;
  }

  Map<String, Vector3D> getPointAndDirection() {
    return {'point': point, 'direction': direction};
  }

  static ThreeDLine fromTwoPoints(Vector3D p1, Vector3D p2) {
    if (p1 == p2) {
      throw Exception('Points must be distinct to define a line.');
    }
    final Vector3D direction = p2 - p1 as Vector3D;
    return ThreeDLine(p1, direction);
  }

  String toSymmetricForm() {
    String xPart = direction.x != 0
      ? '(x - ${point.x}) / ${direction.x}'
      : 'x = ${point.x}';
    
    String yPart = direction.y != 0
      ? '(y - ${point.y}) / ${direction.y}'
      : 'y = ${point.y}';

    String zPart = direction.z != 0
      ? '(z - ${point.z}) / ${direction.z}'
      : 'z = ${point.z}';

    if (direction.x != 0 && direction.y != 0 && direction.z != 0) {
      return '$xPart = $yPart = $zPart';
    } else if (direction.x != 0 && direction.y != 0) {
      return '$xPart = $yPart, $zPart';
    } else if (direction.x != 0 && direction.z != 0) {
      return '$xPart = $zPart, $yPart';
    } else if (direction.y != 0 && direction.z != 0) {
      return '$yPart = $zPart, $xPart';
    } else {
      return '$xPart, $yPart, $zPart';
    }
  }

  Map<String, String> toParametricForm() {
    return {
      'x': 'x = ${point.x} + ${direction.x}t',
      'y': 'y = ${point.y} + ${direction.y}t',
      'z': 'z = ${point.z} + ${direction.z}t',
    };
  }
}

class Plane extends MathObject {
  Set<MathObject> objects = {};
  List<Vector3D> basisVectors = [
    Vector3D(1.0, 0.0, 0.0),
    Vector3D(0.0, 1.0, 0.0),
  ];
  Vector3D origin = Vector3D(0.0, 0.0, 0.0);

  @override
  String get objectName => 'TwoDSpace';
  @override
  Map<String, dynamic> get properties => {'number_of_objects': objects.length};

  List<Vector3D> getBasisVectors() {
    return basisVectors;
  }

  Vector3D getOrigin() {
    return origin;
  }

  void setBasisVectors(List<Vector3D> vectors) {
    bool isValidBasis = areValidBasisVectors(vectors)["isValid"];
    if (!isValidBasis) {
      throw Exception(
        'Provided vectors do not form a valid basis for the plane.',
      );
    } else {
      basisVectors = vectors;
    }
  }

  void setOrigin(Vector3D newOrigin) {
    origin = newOrigin;
  }

  void addObject(MathObject obj) {
    // TODO: Validate that obj is a 2D object
    objects.add(obj);
  }

  Set<MathObject> getObjects() {
    return objects;
  }

  void removeObject(MathObject obj) {
    objects.remove(obj);
  }

  /// Returns a map of variable and coeffecient values in the equation
  /// form of a [Plane].
  /// Example: Ax + By + Cz + D = 0 returns the map
  /// {'A': A, 'B': B, 'C': C, 'D': D}

  Map<String, double> getEquationParameters() {
    Vector3D e1 = basisVectors[0];
    Vector3D e2 = basisVectors[1];
    Vector3D normalVector = e1.cross(e2);

    double A = normalVector.x;
    double B = normalVector.y;
    double C = normalVector.z;
    double D = -(A * origin.x + B * origin.y + C * origin.z);
    
    return {'A': A, 'B': B, 'C': C, 'D': D};
  }

  List<double> calculateTwoDLineSolution(TwoDLine line_1, TwoDLine line_2) {
    if (line_1.slope == line_2.slope) {
      if (line_1.intercept == line_2.intercept) {
        throw Exception('Infinite solutions: lines are identical.');
      } else {
        throw Exception('No solution: lines are parallel.');
      }
    }

    double x =
        (line_2.intercept - line_1.intercept) / (line_1.slope - line_2.slope);
    double y = line_1.slope * x + line_1.intercept;
    return [x, y];
  }
}

class ThreeDSpace extends MathObject {
  Set<MathObject> objects = {};
  List<Vector3D> basisVectors = [
    Vector3D(1.0, 0.0, 0.0),
    Vector3D(0.0, 1.0, 0.0),
    Vector3D(0.0, 0.0, 1.0),
  ];
  Vector3D origin = Vector3D(0.0, 0.0, 0.0);

  @override
  String get objectName => 'ThreeDSpace';
  @override
  Map<String, dynamic> get properties => {'number_of_objects': objects.length};

  void addObject(MathObject obj) {
    // TODO: Validate that obj is a 3D or 2D object
    objects.add(obj);
  }

  Set<MathObject> getObjects() {
    return objects;
  }

  void removeObject(MathObject obj) {
    objects.remove(obj);
  }

  void embedPlane(Plane plane) {}
}
