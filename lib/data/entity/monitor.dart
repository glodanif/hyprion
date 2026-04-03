import 'dart:math';
import 'dart:ui';

import 'package:hyprion/data/entity/transform.dart';

class Monitor {
  final String id;
  final String name;
  final int refreshRate;
  final double scale;
  final Size size;
  final Point<int> position;
  final Transform transform;
  final bool isEnabled;

  Monitor({
    required this.id,
    required this.name,
    required this.refreshRate,
    required this.scale,
    required this.size,
    required this.position,
    required this.transform,
    required this.isEnabled,
  });
}
