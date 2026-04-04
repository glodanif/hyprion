import 'dart:math' as math;
import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hyprion/data/entity/transformation.dart';

class TransformationSelector extends StatefulWidget {
  final Transformation initialValue;
  final ValueChanged<Transformation>? onChanged;

  const TransformationSelector({
    super.key,
    required this.initialValue,
    this.onChanged,
  });

  @override
  State<TransformationSelector> createState() => _TransformationSelectorState();
}

class _TransformationSelectorState extends State<TransformationSelector> {
  late Transformation _selectedTransformation;

  @override
  void initState() {
    super.initState();
    _selectedTransformation = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Column(
        children: [
          const Text(
            'Transformation',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildTransformationIcon(_selectedTransformation),
          const SizedBox(height: 16),
          DropdownFlutter<Transformation>(
            hintText: 'Select transformation',
            items: Transformation.values,
            initialItem: _selectedTransformation,
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                _selectedTransformation = value;
              });
              widget.onChanged?.call(value);
            },
            listItemBuilder: (context, item, isSelected, onItemSelect) {
              return Text(item.label);
            },
            headerBuilder: (context, selectedItem, enabled) {
              return Text(selectedItem.label);
            },
          ),
        ],
      ),
    );
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
