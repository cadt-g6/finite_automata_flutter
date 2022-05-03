import 'package:flutter/material.dart';

class FaTextField extends StatelessWidget {
  const FaTextField({
    Key? key,
    this.hintText,
    required this.labelText,
    this.onChanged,
    this.validator,
    this.initialValue,
  }) : super(key: key);

  final String? initialValue;
  final String? hintText;
  final String? labelText;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      validator: validator,
      initialValue: initialValue,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: labelText,
        hintText: hintText,
      ),
    );
  }
}
