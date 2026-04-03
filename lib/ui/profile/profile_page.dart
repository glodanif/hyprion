import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyprion/data/entity/display.dart';
import 'package:hyprion/sl/service_locator.dart';
import 'package:hyprion/ui/profile/bloc/profile_cubit.dart';

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
    return Column(
      children: [
        Container(
          width: 512,
          height: 256,
          color: Colors.blue,
          padding: const EdgeInsets.all(16.0),
          child: Placeholder(),
        ),
        const SizedBox(height: 16.0),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 3.0,
            children: [
              for (var i = 0; i < state.displays.length; i++)
                _buildDisplay(context, state.displays[i]),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDisplay(BuildContext context, Display display) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 24.0),
                  child: Text(
                    display.id.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      display.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(display.description),
                  ],
                ),
                const Spacer(),
                FilledButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                      display.isEnabled ? Colors.grey : Colors.lightBlue,
                    ),
                  ),
                  child: Text(!display.isEnabled ? 'Enable' : 'Disable'),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: Column(
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
            ),
          ],
        ),
      ),
    );
  }
}
