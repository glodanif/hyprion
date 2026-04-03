import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyprion/sl/service_locator.dart';
import 'package:hyprion/ui/common/animated_visibility.dart';
import 'package:hyprion/ui/profile/bloc/profile_cubit.dart';
import 'package:hyprion/ui/profile/component/monitor_header.dart';
import 'package:hyprion/ui/profile/component/monitors_canvas.dart';
import 'package:hyprion/ui/profile/view_entity/monitor_view_entity.dart';

import 'bloc/profile_state.dart';

class ProfilePage extends StatelessWidget {
  final String? profileId;

  const ProfilePage({super.key, required this.profileId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCubit>(
      create: (context) => getIt<ProfileCubit>()..loadProfile(profileId),
      child: Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: SafeArea(
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              switch (state) {
                case ProfileLoadingState():
                  return const Center(child: CircularProgressIndicator());
                case ProfileLoadedState():
                  return _buildProfile(context, state);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProfile(BuildContext context, ProfileLoadedState state) {
    return ListView(
      children: [
        Center(child: MonitorsCanvas()),
        ...state.monitors.map((monitor) => _buildMontorItem(context, monitor)),
      ],
    );
  }

  Widget _buildMontorItem(BuildContext context, MonitorViewEntity monitor) {
    return Column(
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
        AnimatedVisibility(
          visible: monitor.display.isEnabled,
          child: _buildDisplay(context, monitor),
        ),
      ],
    );
  }

  Widget _buildDisplay(BuildContext context, MonitorViewEntity monitor) {
    final display = monitor.display;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mode: ${display.resolution.width}x${display.resolution.height} ${display.refreshRate}Hz',
          ),
          Text(
            'Position: ${display.currentPosition.x}x${display.currentPosition.y}',
          ),
          Text('Scale: x${display.scale}'),
          Text('Transformation: ${display.transformation.label}'),
          if (display.mirrorOfId.isNotEmpty)
            Text('Mirror of ${display.mirrorOfId}'),
        ],
      ),
    );
  }
}
