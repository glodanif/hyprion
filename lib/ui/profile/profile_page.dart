import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyprion/sl/service_locator.dart';
import 'package:hyprion/ui/common/animated_visibility.dart';

import 'bloc/profile_cubit.dart';
import 'bloc/profile_state.dart';
import 'component/incremental_number_input.dart';
import 'component/mode_selector.dart';
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
    debugPrint('profileId: $profileId');
    return BlocProvider<ProfileCubit>(
      create: (context) => getIt<ProfileCubit>()..loadProfile(profileId),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listenWhen: (previous, current) => current is ProfileCompletedState,
        listener: (context, state) {
          if (state is ProfileCompletedState) {
            Navigator.of(context).pop();
          }
        },
        buildWhen: (previous, current) => current is! ProfileCompletedState,
        builder: (context, state) {
          final titleWidget = state is ProfileLoadedState
              ? ProfileNameInput(
                  initialValue: state.profile.name,
                  onSubmitted: (name) {
                    context.read<ProfileCubit>().setProfileName(name);
                  },
                )
              : const Text('...');

          return Scaffold(
            appBar: AppBar(
              title: titleWidget,
              actions: state is ProfileLoadedState
                  ? [
                      FilledButton.icon(
                        onPressed: () {
                          context.read<ProfileCubit>().saveProfile();
                        },
                        icon: const Icon(Icons.save),
                        label: const Text('Save'),
                      ),
                      if (state.profile.id.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: FilledButton.icon(
                            onPressed: () {
                              context.read<ProfileCubit>().removeProfile();
                            },
                            icon: const Icon(Icons.delete),
                            label: const Text('Remove'),
                          ),
                        ),
                      const SizedBox(width: 16),
                    ]
                  : [],
            ),
            body: SafeArea(
              child: switch (state) {
                ProfileLoadingState() => const Center(
                  child: CircularProgressIndicator(),
                ),
                ProfileLoadedState() => _buildProfile(context, state),
                _ => const Center(child: Text('Unknown state')),
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfile(BuildContext context, ProfileLoadedState state) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 32),
      children: [
        Center(child: MonitorsCanvas()),
        const SizedBox(height: 32),
        ...state.monitors.map(
          (monitor) => Card(child: _buildMontorItem(context, monitor)),
        ),
      ],
    );
  }

  Widget _buildMontorItem(BuildContext context, MonitorViewEntity monitor) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MonitorHeader(
          display: monitor.display,
          isAvailable: monitor.isAvailable,
          onEnabledChanged: (enabled) {
            if (!monitor.isAvailable) return;
            context.read<ProfileCubit>().setEnabled(
              monitor.display.id,
              enabled,
            );
          },
        ),
        if (!monitor.isAvailable)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextButton(
              onPressed: () {
                context.read<ProfileCubit>().removeUnavailableMonitor(
                  monitor.display.id,
                );
              },
              child: const Text('Remove', style: TextStyle(color: Colors.red)),
            ),
          ),
        if (monitor.isAvailable)
          AnimatedVisibility(
            visible: monitor.display.isEnabled,
            child: _buildDisplay(context, monitor),
          ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: monitor.isAvailable
          ? content
          : Opacity(opacity: 0.6, child: content),
    );
  }

  Widget _buildDisplay(BuildContext context, MonitorViewEntity monitor) {
    final display = monitor.display;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ModeSelector(
            display: display,
            onModeChanged: (width, height, refreshRate) {
              context.read<ProfileCubit>().setMode(
                display.id,
                width,
                height,
                refreshRate,
              );
            },
          ),
          IncrementalNumberInput(
            value: display.scale,
            minValue: 0.1,
            maxValue: 10.0,
            step: 0.01,
            onChanged: (value) {
              context.read<ProfileCubit>().setScale(display.id, value);
            },
          ),
          TransformationSelector(
            initialValue: display.transformation,
            onChanged: (value) {
              context.read<ProfileCubit>().setTransformation(display.id, value);
            },
          ),
        ],
      ),
    );
  }
}
