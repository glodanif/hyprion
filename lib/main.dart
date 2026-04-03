import 'package:flutter/material.dart';
import 'package:hyprion/sl/service_locator.dart';

import 'router.dart';

void main() async {
  const useMocks = String.fromEnvironment('USE_MOCKS') == 'true';
  initDependencies(useMocks: useMocks);
  runApp(const HyprionApp());
}

class HyprionApp extends StatelessWidget {
  const HyprionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Hyprion',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepOrange)),
      routerConfig: router,
    );
  }
}
