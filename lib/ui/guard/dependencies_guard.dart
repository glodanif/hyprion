import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyprion/sl/service_locator.dart';

import 'bloc/guard_cubit.dart';
import 'bloc/guard_state.dart';

class DependenciesGuard extends StatelessWidget {
  final Widget child;

  const DependenciesGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<GuardCubit>()..checkDependencies(),
      child: BlocBuilder<GuardCubit, GuardState>(
        builder: (context, state) {
          switch (state) {
            case GuardLoadingState():
              return const Center(child: CircularProgressIndicator());
            case GuardDependenciesCheckedState():
              return _buildGuard(context, state);
          }
        },
      ),
    );
  }

  Widget _buildGuard(
    BuildContext context,
    GuardDependenciesCheckedState state,
  ) {
    if (!state.isWindowManagerRunning) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('${state.windowManagerName} is not running'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<GuardCubit>().checkDependencies();
            },
            child: Text("Check again"),
          ),
        ],
      );
    }

    return child;
  }
}
