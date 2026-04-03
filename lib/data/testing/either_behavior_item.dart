import 'package:fpdart/fpdart.dart';

class EitherBehaviorItem<T, V> {
  final Either<T, V> result;
  final Duration timeToComplete;

  const EitherBehaviorItem({
    required this.result,
    this.timeToComplete = const Duration(seconds: 1),
  });
}
