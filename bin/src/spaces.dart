import 'base.dart';

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
}

class ThreeDLine extends Line {
  final List<double> point; // A point on the line [x, y, z]
  final List<double> direction; // Direction vector of the line [dx, dy, dz]

  @override
  String get objectName => 'ThreeDLine';
  @override
  Map<String, dynamic> get properties => {
    'point': point,
    'direction': direction,
  };

  ThreeDLine(this.point, this.direction) {
    if (point.length != 3) {
      throw Exception('Point must be a 3-dimensional vector.');
    }
    if (direction.length != 3) {
      throw Exception('Direction must be a 3-dimensional vector.');
    }
    if (direction.every((d) => d == 0)) {
      throw Exception('Direction vector cannot be the zero vector.');
    }
  }

  static ThreeDLine fromPointAndDirection(
    List<double> point,
    List<double> direction,
  ) {
    return ThreeDLine(point, direction);
  }

  Map<String, List<double>> getPointAndDirection() {
    return {'point': point, 'direction': direction};
  }
}

class Plane extends MathObject {
  Set<MathObject> objects = {};

  @override
  String get objectName => 'TwoDSpace';
  @override
  Map<String, dynamic> get properties => {'number_of_objects': objects.length};

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
