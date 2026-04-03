import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hyprion/data/entity/transformation.dart';

class TransformationSelector extends StatelessWidget {
  final Transformation initialValue;
  final ValueChanged<Transformation>? onChanged;

  const TransformationSelector({
    super.key,
    required this.initialValue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showBottomSheet(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            _buildTransformationIcon(initialValue),
            const SizedBox(width: 24),
            Text(initialValue.label),
            const SizedBox(width: 16),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  Future<void> _showBottomSheet(BuildContext context) async {
    final result = await showModalBottomSheet<Transformation>(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: Transformation.values.length,
          itemBuilder: (context, index) {
            final value = Transformation.values[index];
            final isSelected = value == initialValue;

            return InkWell(
              onTap: () => Navigator.pop(context, value),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                color: isSelected
                    ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                    : null,
                child: Row(
                  children: [
                    _buildTransformationIcon(value),
                    const SizedBox(width: 24),
                    Text(value.label),
                    const SizedBox(width: 16),
                    if (isSelected)
                      Icon(Icons.check, color: Theme.of(context).primaryColor),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (result != null && onChanged != null) {
      onChanged!(result);
    }
  }

  Widget _buildTransformationIcon(Transformation value) {
    return SizedBox(
      width: 72,
      height: 72,
      child: ClipRect(
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Transform.rotate(
                angle: value.angle * math.pi / 180,
                alignment: Alignment.center,
                child: Transform.scale(
                  scaleX: value.isFlipped ? -1.0 : 1.0,
                  scaleY: 1.0,
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    'assets/icon_monitor_transformation.svg',
                    width: 72,
                    height: 72,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Transform.scale(
                scaleX: value.isFlipped ? -1.0 : 1.0,
                alignment: Alignment.center,
                child: const Text('abc'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
