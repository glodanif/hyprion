import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IncrementalNumberInput extends StatefulWidget {
  final double value;
  final Function(double) onChanged;
  final double minValue;
  final double maxValue;
  final double step;

  const IncrementalNumberInput({
    super.key,
    required this.value,
    required this.onChanged,
    this.minValue = 0,
    this.maxValue = double.infinity,
    this.step = 1,
  });

  @override
  State<IncrementalNumberInput> createState() => _IncrementalNumberInputState();
}

class _IncrementalNumberInputState extends State<IncrementalNumberInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  double _value = 0.0;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
    _controller.text = _value.toStringAsFixed(2);

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        // Format when user leaves the field
        _controller.text = _value.toStringAsFixed(2);
      }
    });
  }

  @override
  void didUpdateWidget(IncrementalNumberInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && !_focusNode.hasFocus) {
      _value = widget.value;
      _controller.text = _value.toStringAsFixed(2);
    }
  }

  void _incrementValue(double delta) {
    final newValue = (_value + delta).clamp(widget.minValue, widget.maxValue);
    setState(() {
      _value = newValue;
      _controller.text = _value.toStringAsFixed(2);
    });
    widget.onChanged(newValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Column(
        children: [
          const Text('Scale', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () => _incrementValue(-widget.step),
              ),
              SizedBox(
                width: 80,
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textAlign: TextAlign.center,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*\.?\d{0,2}'),
                    ),
                  ],
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 12,
                    ),
                  ),
                  onChanged: (value) {
                    if (value.isEmpty) return;
                    final parsedValue = double.tryParse(value);
                    if (parsedValue != null) {
                      final clampedValue = parsedValue.clamp(
                        widget.minValue,
                        widget.maxValue,
                      );
                      _value = clampedValue;
                      widget.onChanged(clampedValue);
                    }
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _incrementValue(widget.step),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
