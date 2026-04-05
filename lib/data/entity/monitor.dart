import 'dart:math';

import 'package:hyprion/data/entity/display.dart';
import 'package:hyprion/data/entity/transformation.dart';

class Monitor {
  final int id;
  final String name;
  final String model;
  final double refreshRate;
  final double scale;
  final Size size;
  final Point<int> position;
  final Transformation transformation;
  final bool isEnabled;
  final String mirrorOfName;

  Monitor({
    required this.id,
    required this.name,
    required this.model,
    required this.refreshRate,
    required this.scale,
    required this.size,
    required this.position,
    required this.transformation,
    required this.isEnabled,
    required this.mirrorOfName,
  });
}
