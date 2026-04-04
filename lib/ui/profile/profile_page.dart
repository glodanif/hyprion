import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyprion/sl/service_locator.dart';
import 'package:hyprion/ui/common/animated_visibility.dart';

import 'bloc/profile_cubit.dart';
import 'bloc/profile_state.dart';
import 'component/monitor_header.dart';
import 'component/monitors_canvas.dart';
import 'component/profile_name_input.dart';
import 'component/transformation_selector.dart';
import 'view_entity/monitor_view_entity.dart';

class ProfilePage extends StatelessWidget {
  final String? profileId;

  const ProfilePage({super.key, required this.profileId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCubit>(
      create: (context) => getIt<ProfileCubit>()..loadProfile(profileId),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final titleWidget = state is ProfileLoadedState
              ? ProfileNameInput(initialValue: state.profile?.name)
              : const Text('...');

          return Scaffold(
            appBar: AppBar(title: titleWidget),
            body: SafeArea(
              child: switch (state) {
                ProfileLoadingState() => const Center(
                  child: CircularProgressIndicator(),
                ),
                ProfileLoadedState() => _buildProfile(context, state),
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfile(BuildContext context, ProfileLoadedState state) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 32),
      children: [
        Center(child: MonitorsCanvas()),
        const SizedBox(height: 32),
        ...state.monitors.map((monitor) => _buildMontorItem(context, monitor)),
      ],
    );
  }

  Widget _buildMontorItem(BuildContext context, MonitorViewEntity monitor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MonitorHeader(
            display: monitor.display,
            onEnabledChanged: (enabled) {
              context.read<ProfileCubit>().setEnabled(
                monitor.display.id,
                enabled,
              );
            },
          ),
          const SizedBox(height: 16),
          AnimatedVisibility(
            visible: monitor.display.isEnabled,
            child: _buildDisplay(context, monitor),
          ),
        ],
      ),
    );
  }

  Widget _buildDisplay(BuildContext context, MonitorViewEntity monitor) {
    final display = monitor.display;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Mode: ${display.resolution.width}x${display.resolution.height} ${display.refreshRate}Hz',
          ),
          Text(
            'Position: ${display.currentPosition.x}x${display.currentPosition.y}',
          ),
          Text('Scale: x${display.scale}'),
          TransformationSelector(
            initialValue: display.transformation,
            onChanged: (value) {
              context.read<ProfileCubit>().setTransformation(display.id, value);
            },
          ),
          if (display.mirrorOfId.isNotEmpty)
            Text('Mirror of ${display.mirrorOfId}'),
        ],
      ),
    );
  }
}
