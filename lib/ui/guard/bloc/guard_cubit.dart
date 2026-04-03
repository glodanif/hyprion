import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyprion/data/dependencies/dependencies.dart';

import 'guard_state.dart';

class GuardCubit extends Cubit<GuardState> {
  final Dependencies _dependencies;

  GuardCubit(this._dependencies) : super(GuardLoadingState());

  Future<void> checkDependencies() async {
    emit(GuardLoadingState());
    final isWindowManagerRunning = await _dependencies.isWindowManagerRunning();
    emit(
      GuardDependenciesCheckedState(
        windowManagerName: _dependencies.windowMangerName,
        isWindowManagerRunning: isWindowManagerRunning,
      ),
    );
  }
}
