import 'package:flutter/material.dart';

class ProfileNameInput extends StatefulWidget {
  final String? initialValue;
  final Function(String)? onSubmitted;

  const ProfileNameInput({super.key, this.initialValue, this.onSubmitted});

  @override
  State<ProfileNameInput> createState() => _ProfileNameInputState();
}

class _ProfileNameInputState extends State<ProfileNameInput> {
  final _controller = TextEditingController();
  var _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialValue ?? 'Unnamed Profile';
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyLarge;

    return Row(
      children: [
        if (!_isEditing)
          Text(_controller.text, style: textStyle)
        else
          SizedBox(
            width: 256,
            child: TextFormField(
              controller: _controller,
              style: textStyle,
              decoration: const InputDecoration(hintText: 'Profile Name'),
            ),
          ),
        const SizedBox(width: 16),

        if (_isEditing)
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              setState(() {
                _isEditing = false;
                widget.onSubmitted?.call(_controller.text);
              });
            },
          )
        else
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = true;
              });
            },
          ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
