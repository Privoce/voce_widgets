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
      this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextField(
        keyboardType: keyboardType,
        decoration: InputDecoration(
            filled: filled,

            // fillColor: Colors.black,
            // border: InputBorder.none,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide.none),
            isCollapsed: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 8)),
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
    );
  }
}
