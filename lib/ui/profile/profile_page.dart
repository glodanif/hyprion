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
                _buildDisplay(state.displays[i]),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDisplay(Display display) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              display.id.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            const SizedBox(width: 12.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${display.name} | ${display.model}'),
                Text(display.description),
              ],
            ),
            const Spacer(),
            if (!display.isEnabled) const Text('Disabled'),
            const SizedBox(width: 8.0),
            Checkbox(value: display.isEnabled, onChanged: (value) {}),
          ],
        ),
      ),
    );
  }
}
