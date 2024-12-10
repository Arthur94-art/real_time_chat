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
  final double borderRadius;

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
    this.borderRadius = 8.0,
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
        hintStyle: hintStyle,
        filled: true,
        fillColor: fillColor,
        border: isOutlined
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: const BorderSide(color: Colors.greenAccent),
              )
            : InputBorder.none,
        focusedBorder: isOutlined
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide:
                    const BorderSide(color: Colors.greenAccent, width: 1),
              )
            : InputBorder.none,
      ),
    );
  }
}
