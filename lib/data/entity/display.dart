import 'dart:math';

import 'package:hyprion/data/entity/transform.dart';

class Display {
  final int id;
  final String name;
  final String model;
  final String description;
  final double scale;
  final Transform transform;
  final Size resolution;
  final double refreshRate;
  final bool isEnabled;
  final String mirrorOfId;
  final Point<int> currentPosition;
  final List<Mode> availableModes;

  const Display({
    required this.id,
    required this.name,
    required this.model,
    required this.description,
    required this.scale,
    required this.transform,
    required this.resolution,
    required this.refreshRate,
    required this.isEnabled,
    required this.mirrorOfId,
    required this.currentPosition,
    required this.availableModes,
  });

  @override
  String toString() {
    return 'Display(id: $id, name: $name, model: $model, description: $description, scale: $scale, transform: $transform, resolution: $resolution, refreshRate: $refreshRate, isEnabled: $isEnabled, mirrorOfId: $mirrorOfId, currentPosition: $currentPosition, availableMods: $availableModes)';
  }
}

class Mode {
  final int width;
  final int height;
  final List<double> refreshRates;

  const Mode({
    required this.width,
    required this.height,
    required this.refreshRates,
  });

  @override
  String toString() {
    return 'Mode(width: $width, height: $height, refreshRates: $refreshRates)';
  }
}

class Size {
  final int width;
  final int height;

  const Size({required this.width, required this.height});

  @override
  String toString() {
    return 'Size(width: $width, height: $height)';
  }
}
