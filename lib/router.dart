import 'package:go_router/go_router.dart';
import 'package:hyprion/ui/guard/dependencies_guard.dart';
import 'package:hyprion/ui/home/home_page.dart';
import 'package:hyprion/ui/profile/profile_page.dart';

enum RoutePath {
  home('/'),
  profile('/profile');

  final String path;

  const RoutePath(this.path);
}

final router = GoRouter(
  routes: [
    GoRoute(
      path: RoutePath.home.path,
      builder: (context, state) => DependenciesGuard(child: HomePage()),
    ),
    GoRoute(
      path: RoutePath.profile.path,
      builder: (context, state) =>
          ProfilePage(profileId: state.uri.queryParameters['id']),
    ),
  ],
);
