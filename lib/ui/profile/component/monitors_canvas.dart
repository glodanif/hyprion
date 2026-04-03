import 'package:flutter/material.dart';

class MonitorsCanvas extends StatelessWidget {
  const MonitorsCanvas({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 512,
      height: 256,
      color: Colors.blue,
      padding: const EdgeInsets.all(16.0),
      child: Placeholder(),
    );
  }
}
