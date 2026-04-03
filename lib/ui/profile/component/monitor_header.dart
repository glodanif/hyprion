import 'package:flutter/material.dart';
import 'package:hyprion/data/entity/display.dart';

class MonitorHeader extends StatelessWidget {
  final Display display;
  final Function(bool) onEnabledChanged;

  const MonitorHeader({
    super.key,
    required this.display,
    required this.onEnabledChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 24.0),
          child: Text(
            display.id.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(display.name, style: Theme.of(context).textTheme.titleLarge),
            Text(display.description),
          ],
        ),
        const Spacer(),
        FilledButton(
          onPressed: () => onEnabledChanged(!display.isEnabled),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(
              display.isEnabled ? Colors.grey : Colors.lightBlue,
            ),
          ),
          child: Text(!display.isEnabled ? 'Enable' : 'Disable'),
        ),
      ],
    );
  }
}
