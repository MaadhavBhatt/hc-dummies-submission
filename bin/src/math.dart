class TwoDObject {}

class ThreeDObject {}

class TwoDLine extends TwoDObject {
  final double slope;
  final double intercept;

  TwoDLine(this.slope, this.intercept) {
    if (slope.isInfinite) {
      throw Exception('Slope cannot be infinite for a 2D line.');
    }
    if (intercept.isInfinite) {
      throw Exception('Intercept cannot be infinite for a 2D line.');
    }
  }

  @override
  String toString() {
    return 'TwoDLine(slope: $slope, intercept: $intercept)';
  }
}

class ThreeDLine extends ThreeDObject {
  final List<double> point; // A point on the line [x, y, z]
  final List<double> direction; // Direction vector of the line [dx, dy, dz]

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

  @override
  String toString() {
    return 'ThreeDLine(point: $point, direction: $direction)';
  }
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
