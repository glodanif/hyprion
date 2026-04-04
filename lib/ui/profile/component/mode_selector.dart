import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:hyprion/data/entity/display.dart';

class ModeSelector extends StatefulWidget {
  final Display display;
  final Function(int width, int height, double refreshRate) onModeChanged;

  const ModeSelector({
    super.key,
    required this.display,
    required this.onModeChanged,
  });

  @override
  State<ModeSelector> createState() => _ModeSelectorState();
}

class _ModeSelectorState extends State<ModeSelector> {
  late Mode _selectedMode;
  late double _selectedRefreshRate;

  @override
  void initState() {
    super.initState();
    _initializeSelection();
  }

  @override
  void didUpdateWidget(ModeSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.display != widget.display) {
      _initializeSelection();
    }
  }

  void _initializeSelection() {
    // Find the mode that matches the current resolution
    final currentMode = widget.display.availableModes.firstWhere(
      (mode) =>
          mode.width == widget.display.resolution.width &&
          mode.height == widget.display.resolution.height,
      orElse: () => widget.display.availableModes.first,
    );

    _selectedMode = currentMode;

    // Find the refresh rate that's closest to the current one
    _selectedRefreshRate = currentMode.refreshRates.reduce((closest, rate) {
      final currentDiff = (rate - widget.display.refreshRate).abs();
      final closestDiff = (closest - widget.display.refreshRate).abs();
      return currentDiff < closestDiff ? rate : closest;
    });
  }

  void _onResolutionChanged(String? resolutionString) {
    if (resolutionString == null) return;
    final parts = resolutionString.split('x');
    final width = int.parse(parts[0]);
    final height = int.parse(parts[1]);

    final newMode = widget.display.availableModes.firstWhere(
      (mode) => mode.width == width && mode.height == height,
    );

    setState(() {
      _selectedMode = newMode;
      // Select the first refresh rate for newly selected resolution
      _selectedRefreshRate = newMode.refreshRates.first;
    });

    widget.onModeChanged(width, height, _selectedRefreshRate);
  }

  void _onRefreshRateChanged(double? refreshRate) {
    if (refreshRate == null) return;
    setState(() {
      _selectedRefreshRate = refreshRate;
    });

    widget.onModeChanged(
      _selectedMode.width,
      _selectedMode.height,
      refreshRate,
    );
  }

  String _getResolutionString(Mode mode) {
    return '${mode.width}x${mode.height}';
  }

  @override
  Widget build(BuildContext context) {
    // Get unique resolutions
    final resolutions = widget.display.availableModes
        .map((mode) => _getResolutionString(mode))
        .toSet()
        .toList();

    return SizedBox(
      width: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Mode', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          DropdownFlutter<String>(
            hintText: 'Select resolution',
            items: resolutions,
            initialItem: _getResolutionString(_selectedMode),
            onChanged: _onResolutionChanged,
          ),
          const SizedBox(height: 16),
          DropdownFlutter<double>(
            hintText: 'Select refresh rate',
            items: _selectedMode.refreshRates,
            initialItem: _selectedRefreshRate,
            onChanged: _onRefreshRateChanged,
            listItemBuilder: (context, item, isSelected, onItemSelect) {
              return Text('${item.toStringAsFixed(2)} Hz');
            },
            headerBuilder: (context, selectedItem, enabled) {
              return Text('${selectedItem.toStringAsFixed(2)} Hz');
            },
          ),
        ],
      ),
    );
  }
}
