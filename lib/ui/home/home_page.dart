import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hyprion/data/entity/profile.dart';
import 'package:hyprion/router.dart';
import 'package:hyprion/sl/service_locator.dart';

import 'bloc/home_cubit.dart';
import 'bloc/home_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeCubit>()..loadProfiles(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Profiles')),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            switch (state) {
              case HomeLoadingState():
                return const Center(child: CircularProgressIndicator());
              case HomeLoadedState():
                return _buildProfiles(context, state.config.profiles);
            }
          },
        ),
      ),
    );
  }

  Widget _buildProfiles(BuildContext context, List<Profile> profiles) {
    if (profiles.isEmpty) {
      return Center(
        child: Column(
          children: [
            const Text('No profiles found'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _openProfile(context, null);
              },
              child: Text("Add profile"),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: profiles.length + 1,
      itemBuilder: (context, index) {
        if (index == profiles.length) {
          return ElevatedButton(
            onPressed: () {
              _openProfile(context, null);
            },
            child: Text("Add profile"),
          );
        }
        final profile = profiles[index];
        return ListTile(
          title: Text(profile.name),
          onTap: () => _openProfile(context, profile.id),
        );
      },
    );
  }

  Future<void> _openProfile(BuildContext context, String? profileId) async {
    debugPrint('Opening profile: $profileId');

    if (profileId == null) {
      await context.push(RoutePath.profile.path);
    } else {
      await context.push('${RoutePath.profile.path}?id=$profileId');
    }
    if (context.mounted) {
      context.read<HomeCubit>().loadProfiles();
    }
  }
}
