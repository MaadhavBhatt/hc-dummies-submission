/// An abstract class representing a general mathematical object.
/// Provides a base for more specific mathematical entities.
/// Provides a common toString method for easy representation.
abstract class MathObject {
  // These values are intended to be overridden by subclasses.
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

/// An abstract class representing a 2D mathematical object.
/// Extends [MathObject].
abstract class TwoDObject extends MathObject {
  @override
  String get objectName => 'Unknown TwoDObject';
}

/// An abstract class representing a 3D mathematical object.
/// Extends [MathObject].
abstract class ThreeDObject extends MathObject {
  @override
  String get objectName => 'Unknown ThreeDObject';
}
