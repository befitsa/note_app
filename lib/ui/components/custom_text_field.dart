import 'package:flutter/material.dart';
import '../common/app_sizes.dart';
import '../common/ui_helpers.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hint;
  final int? maxLines;
  final int? maxLength;
  final TextStyle? style;
  final bool autofocus;
  final ValueChanged<String>? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool showBorder;
  const CustomTextField({
    super.key,
    required this.controller,
    this.hint,
    this.maxLines = 1,
    this.maxLength,
    this.style,
    this.autofocus = false,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.showBorder = true,
    });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      autofocus: autofocus,
      onChanged: onChanged,
      style: style ?? TextStyle(color: context.textPrimary, fontSize: 15),
      cursorColor: Theme.of(context).colorScheme.primary,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: context.textSecondary),
        prefix: prefixIcon,
        suffix: suffixIcon,
        counterText: '',
        filled: true,
        fillColor: context.surfaceColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.inputRadius),
          borderSide: showBorder
          ? BorderSide(color: context.borderColor)
          : BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.inputRadius),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 1.5,
          ),
        )
      ),
    );
  }
}
