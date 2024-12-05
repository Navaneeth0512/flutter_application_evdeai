import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hinttext;
  final String labelText;
  final String? Function(String?)? validator;
  final String? prefixText;
  final List<TextInputFormatter>? inputFormatter;
  final IconData? prefixIcon;
  final VoidCallback? onTap;

  const CustomTextFormField({
    Key? key,
    required this.controller,
    required this.hinttext,
    required this.labelText,
    required this.validator,
    this.prefixText,
    this.inputFormatter,
    this.prefixIcon,
    this.onTap,
    required Null Function(dynamic value) onChanged,
    required bool obscureText,
    required TextInputType keyboardType,
  }) : super(key: key);

  get textColor => null;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        labelText: labelText,
        prefixText: prefixText,
        prefixIcon:
            prefixIcon != null ? Icon(prefixIcon, color: textColor) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      inputFormatters: inputFormatter ?? [],
      validator: validator,
      onTap: onTap,
    );
  }
}
