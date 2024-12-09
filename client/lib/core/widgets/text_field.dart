import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? labelText;
  final bool isOutlined;
  final Color fillColor;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final bool autoFocus;
  final int? maxLines;

  const CustomTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.labelText,
    this.isOutlined = true,
    this.fillColor = Colors.white,
    this.textStyle,
    this.hintStyle,
    this.autoFocus = false,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: autoFocus,
      maxLines: maxLines,
      style: textStyle ?? const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        hintStyle: hintStyle ?? const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: fillColor,
        border: isOutlined
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.grey.shade400),
              )
            : InputBorder.none,
      ),
    );
  }
}
