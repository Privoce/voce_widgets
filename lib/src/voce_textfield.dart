library voce_widgets;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VoceTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final Function(String)? onSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final Widget? title;

  final bool enableMargin;
  final bool enableDeco;
  final double borderRadius;
  final double fontSize;
  final EdgeInsets scrollPadding;
  final bool _filled;
  final Color? color;
  final double height;
  final int? maxLength;
  final InputDecoration? decoration;
  final void Function(String)? onChanged;

  const VoceTextField(this.controller,
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
      this.height = 48,
      this.maxLength,
      this.decoration,
      this.onChanged,
      this.title})
      : _filled = false,
        color = null,
        super(key: key);

  const VoceTextField.filled(this.controller,
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
      this.color,
      this.height = 48,
      this.maxLength,
      this.decoration,
      this.onChanged,
      this.title})
      : _filled = true,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) title!,
        if (title != null) const SizedBox(height: 4),
        SizedBox(
          // height: height,
          child: Center(
            child: TextField(
              keyboardType: keyboardType,
              decoration: decoration ??
                  InputDecoration(
                      filled: _filled,
                      fillColor: color ?? Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                          borderSide: BorderSide.none),
                      isCollapsed: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12)),
              maxLength: maxLength,
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
        ),
      ],
    );
  }
}
