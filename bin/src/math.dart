abstract class MathObject {
  String get objectName => 'Unknown MathObject';
  Map<String, dynamic>? get properties;

  @override
  String toString() {
    final props = properties != null
        ? properties!.entries.map((e) => '${e.key}: ${e.value}').join(', ')
        : '';
    return '$objectName($props)';
  }
}

abstract class TwoDObject extends MathObject {
  @override
  String get objectName => 'Unknown TwoDObject';
}

abstract class ThreeDObject extends MathObject {
  @override
  String get objectName => 'Unknown ThreeDObject';
}

class TwoDSpace extends MathObject {
  Set<TwoDObject> objects = {};

  @override
  String get objectName => 'TwoDSpace';
  @override
  Map<String, dynamic> get properties => {'number_of_objects': objects.length};

  void addObject(TwoDObject obj) {
    objects.add(obj);
  }

  Set<TwoDObject> getObjects() {
    return objects;
  }

  void removeObject(TwoDObject obj) {
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

class Point2D extends TwoDObject {
  final double x;
  final double y;

  @override
  String get objectName => 'Point2D';
  @override
  Map<String, dynamic> get properties => {'x': x, 'y': y};

  Point2D(this.x, this.y);
}

class TwoDLine extends TwoDObject {
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

class ThreeDLine extends ThreeDObject {
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
    if (direction.every((component) => component == 0)) {
      throw Exception('Direction vector cannot be the zero vector.');
    }
  }
}
