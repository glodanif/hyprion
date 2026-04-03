import 'dart:math';

import 'package:fpdart/fpdart.dart';
import 'package:hyprion/data/entity/display.dart';
import 'package:hyprion/data/entity/failure.dart';
import 'package:hyprion/data/entity/transformation.dart';
import 'package:hyprion/data/testing/either_behavior_item.dart';

import '../display_manager.dart';

class DisplayManagerMock implements DisplayManager {
  final DisplayManagerMockBehavior behavior;

  DisplayManagerMock({this.behavior = const DisplayManagerMockBehavior()});

  @override
  Future<Either<List<Display>, Failure>> getAvailableDisplays() {
    return Future.value(behavior.getAvailableDisplaysBehavior.result);
  }
}

class DisplayManagerMockBehavior {
  final EitherBehaviorItem<List<Display>, Failure> getAvailableDisplaysBehavior;

  const DisplayManagerMockBehavior({
    this.getAvailableDisplaysBehavior =
        const EitherBehaviorItem<List<Display>, Failure>(result: Left([])),
  });

  const DisplayManagerMockBehavior.normal()
    : getAvailableDisplaysBehavior =
          const EitherBehaviorItem<List<Display>, Failure>(
            result: Left([
              Display(
                id: 0,
                name: 'HDMI-A-1',
                model: 'Mi TV',
                description: 'Mock XMD Mi TV 0x00000001',
                scale: 2.0,
                transformation: Transformation.normal,
                resolution: Size(width: 4096, height: 2160),
                refreshRate: 29.97,
                isEnabled: false,
                mirrorOfId: '',
                currentPosition: Point(0, 0),
                availableModes: [
                  Mode(
                    width: 3840,
                    height: 2160,
                    refreshRates: [30.00, 29.97, 25.00, 23.98],
                  ),
                  Mode(
                    width: 4096,
                    height: 2160,
                    refreshRates: [29.97, 25.00, 24.00, 23.98],
                  ),
                  Mode(width: 2560, height: 1440, refreshRates: [59.95]),
                  Mode(
                    width: 1920,
                    height: 1080,
                    refreshRates: [60.00, 59.94, 50.00, 29.97, 25.00, 23.98],
                  ),
                  Mode(width: 1280, height: 1024, refreshRates: [60.02]),
                  Mode(width: 1440, height: 900, refreshRates: [59.89]),
                  Mode(
                    width: 1280,
                    height: 720,
                    refreshRates: [60.00, 59.94, 50.00],
                  ),
                  Mode(width: 1024, height: 768, refreshRates: [60.00]),
                  Mode(width: 800, height: 600, refreshRates: [60.32]),
                  Mode(width: 720, height: 576, refreshRates: [50.00]),
                  Mode(width: 720, height: 480, refreshRates: [59.94]),
                  Mode(width: 640, height: 480, refreshRates: [59.94, 59.93]),
                ],
              ),
              Display(
                id: 1,
                name: 'DP-1',
                model: 'DELL U2719DC',
                description: 'Mock Dell Inc. DELL U2719DC 9BSRNS2',
                scale: 1.0,
                transformation: Transformation.normal,
                resolution: Size(width: 2560, height: 1440),
                refreshRate: 59.95100,
                isEnabled: true,
                mirrorOfId: '',
                currentPosition: Point(1920, 0),
                availableModes: [
                  Mode(width: 2560, height: 1440, refreshRates: [59.95]),
                  Mode(width: 2048, height: 1080, refreshRates: [60.00, 24.00]),
                  Mode(
                    width: 1920,
                    height: 1080,
                    refreshRates: [60.00, 59.94, 50.00],
                  ),
                  Mode(width: 1600, height: 1200, refreshRates: [60.00]),
                  Mode(width: 1280, height: 1024, refreshRates: [75.03, 60.02]),
                  Mode(width: 1152, height: 864, refreshRates: [75.00]),
                  Mode(
                    width: 1280,
                    height: 720,
                    refreshRates: [60.00, 59.94, 50.00],
                  ),
                  Mode(width: 1024, height: 768, refreshRates: [75.03, 60.00]),
                  Mode(width: 800, height: 600, refreshRates: [75.00, 60.32]),
                  Mode(width: 720, height: 576, refreshRates: [50.00]),
                  Mode(width: 720, height: 480, refreshRates: [59.94]),
                  Mode(
                    width: 640,
                    height: 480,
                    refreshRates: [75.00, 59.94, 59.93],
                  ),
                ],
              ),
              Display(
                id: 2,
                name: 'DP-2',
                model: 'S23C650',
                description: 'Mock Samsung Electric Company S23C650 HTRD900046',
                scale: 1.0,
                transformation: Transformation.normal,
                resolution: Size(width: 1920, height: 1080),
                refreshRate: 60.0,
                isEnabled: true,
                mirrorOfId: '',
                currentPosition: Point(0, 0),
                availableModes: [
                  Mode(width: 1920, height: 1080, refreshRates: [60.00, 50.00]),
                  Mode(width: 1680, height: 1050, refreshRates: [59.95]),
                  Mode(width: 1600, height: 900, refreshRates: [60.00]),
                  Mode(width: 1280, height: 1024, refreshRates: [75.03, 60.02]),
                  Mode(width: 1440, height: 900, refreshRates: [59.89]),
                  Mode(width: 1280, height: 800, refreshRates: [59.81]),
                  Mode(width: 1152, height: 864, refreshRates: [75.00]),
                  Mode(width: 1280, height: 720, refreshRates: [60.00, 50.00]),
                  Mode(
                    width: 1024,
                    height: 768,
                    refreshRates: [75.03, 70.07, 60.00],
                  ),
                  Mode(
                    width: 800,
                    height: 600,
                    refreshRates: [75.00, 72.19, 60.32, 56.25],
                  ),
                  Mode(width: 720, height: 576, refreshRates: [50.00]),
                  Mode(width: 720, height: 480, refreshRates: [59.94]),
                  Mode(
                    width: 640,
                    height: 480,
                    refreshRates: [75.00, 72.81, 59.94],
                  ),
                ],
              ),
            ]),
          );
}
