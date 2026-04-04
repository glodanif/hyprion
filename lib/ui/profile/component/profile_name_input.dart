import 'package:flutter/material.dart';

class ProfileNameInput extends StatefulWidget {
  final String? initialValue;

  const ProfileNameInput({super.key, this.initialValue});

  @override
  State<ProfileNameInput> createState() => _ProfileNameInputState();
}

class _ProfileNameInputState extends State<ProfileNameInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialValue ?? 'Unnamed Profile';
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      decoration: const InputDecoration(
        hintText: 'Profile Name',
        suffix: Icon(Icons.edit),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
