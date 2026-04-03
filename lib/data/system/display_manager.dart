import 'package:fpdart/fpdart.dart';
import 'package:hyprion/data/entity/display.dart';
import 'package:hyprion/data/entity/failure.dart';

abstract class DisplayManager {
  Future<Either<List<Display>, Failure>> getAvailableDisplays();
}
