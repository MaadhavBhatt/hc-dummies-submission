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
