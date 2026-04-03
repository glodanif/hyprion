sealed class GuardState {}

class GuardLoadingState extends GuardState {}

class GuardDependenciesCheckedState extends GuardState {
  final String windowManagerName;
  final bool isWindowManagerRunning;

  GuardDependenciesCheckedState({
    required this.windowManagerName,
    required this.isWindowManagerRunning,
  });
}
