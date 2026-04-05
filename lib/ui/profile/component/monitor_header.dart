import 'package:flutter/material.dart';
import 'package:hyprion/data/entity/display.dart';

class MonitorHeader extends StatelessWidget {
  final Display display;
  final bool isAvailable;
  final Function(bool) onEnabledChanged;

  const MonitorHeader({
    super.key,
    required this.display,
    required this.isAvailable,
    required this.onEnabledChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SizedBox(
            width: 48,
            child: Text(
              display.id.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(display.name, style: Theme.of(context).textTheme.titleLarge),
            Text(display.description),
            if (!isAvailable)
              const Text(
                'Disconnected',
                style: TextStyle(
                  color: Colors.orange,
                  fontStyle: FontStyle.italic,
                  fontSize: 12,
                ),
              ),
          ],
        ),
        const Spacer(),
        if (isAvailable)
          FilledButton(
            onPressed: () => onEnabledChanged(!display.isEnabled),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(
                display.isEnabled
                    ? Colors.redAccent.shade100
                    : Colors.lightBlue,
              ),
            ),
            child: Text(!display.isEnabled ? 'Enable' : 'Disable'),
          )
        else
          Chip(
            label: const Text('Unavailable'),
            backgroundColor: Colors.grey.shade300,
            labelStyle: TextStyle(color: Colors.grey.shade700),
          ),
      ],
    );
  }
}
