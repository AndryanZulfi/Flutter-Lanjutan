import 'package:flutter/material.dart';

class CustomTextFieldWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final TextInputType keyboardType;
  final String labelText;

  const CustomTextFieldWidget({
    super.key,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        initialValue: initialValue,
        onChanged: onChanged,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: labelText,
        ),
        validator: (value) =>
            value == null || value.isEmpty ? "Please Enter Field" : null,
      ),
    );
  }
}
