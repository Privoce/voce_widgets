library voce_widgets;

import 'package:flutter/material.dart';

class VoceRoundedTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final Function(String)? onSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;

  final bool enableMargin;
  final bool enableDeco;
  final double borderRadius;
  final double fontSize;
  final EdgeInsets scrollPadding;
  final bool filled;
  final Color? color;
  final double height;
  final InputDecoration? decoration;
  final void Function(String)? onChanged;

  const VoceRoundedTextField(this.controller,
      {Key? key,
      this.focusNode,
      this.onSubmitted,
      this.keyboardType,
      this.textInputAction,
      this.obscureText = false,
      this.enableMargin = true,
      this.enableDeco = true,
      this.borderRadius = 8,
      this.fontSize = 16,
      this.scrollPadding = const EdgeInsets.all(20.0),
      this.filled = true,
      this.color,
      this.height = 48,
      this.decoration,
      this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Center(
        child: TextField(
          keyboardType: keyboardType,
          decoration: decoration ??
              InputDecoration(
                  filled: filled,
                  fillColor: color ?? Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                      borderSide: BorderSide.none),
                  isCollapsed: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
          controller: controller,
          focusNode: focusNode,
          autocorrect: false,
          autofocus: true,
          obscureText: obscureText,
          textInputAction: textInputAction,
          textAlignVertical: TextAlignVertical.center,
          onSubmitted: onSubmitted,
          onChanged: onChanged,
          scrollPadding: scrollPadding,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
