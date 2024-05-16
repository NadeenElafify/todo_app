import 'package:flutter/material.dart';

class DefaultFormFiled extends StatelessWidget {
  DefaultFormFiled({
    super.key,
    this.isSecure = true,
    this.suffixIcon,
    this.onTap,
    this.isClickable = true,
    this.suffixPressed,
    required this.validator,
    required this.prefixIcon,
    required this.controller,
    required this.inputType,
    required this.label,
  });
  TextEditingController controller;
  TextInputType inputType;
  Widget prefixIcon;
  String? Function(String?) validator;
  Widget label;
  bool isSecure;
  IconData? suffixIcon;
  VoidCallback? suffixPressed;
  VoidCallback? onTap;
  bool isClickable;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      enabled: isClickable,
      obscureText: isSecure,
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
          prefixIcon: prefixIcon,
          label: label,
          border: OutlineInputBorder(),
          suffixIcon: suffixIcon != null
              ? IconButton(
                  onPressed: suffixPressed,
                  icon: Icon(suffixIcon),
                )
              : null),
      validator: validator,
    );
  }
}
