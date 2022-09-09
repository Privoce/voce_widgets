library voce_widgets;

import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:voce_widgets/src/voce_text_input_formatter.dart';

class VoceTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final Function(String)? onSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final Widget? title;
  final Widget? footer;
  final bool enabled;
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
  final bool enableCounterText;
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
      this.enableCounterText = false,
      this.title,
      this.footer,
      this.enabled = true})
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
      this.title,
      this.footer,
      this.enableCounterText = false,
      this.enabled = true})
      : _filled = true,
        super(key: key);

  @override
  State<VoceTextField> createState() => _VoceTextFieldState();
}

class _VoceTextFieldState extends State<VoceTextField> {
  int? _maxLength;

  @override
  initState() {
    super.initState();
    _maxLength = widget.maxLength ?? 32;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) widget.title!,
        if (widget.title != null) const SizedBox(height: 4),
        SizedBox(
          // height: height,
          child: Center(
            child: TextField(
              enabled: widget.enabled,
              keyboardType: widget.keyboardType,
              decoration: widget.decoration ??
                  InputDecoration(
                      filled: widget._filled,
                      fillColor: widget.color ?? Colors.white,
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(widget.borderRadius),
                          borderSide: BorderSide.none),
                      isCollapsed: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12)),
              buildCounter: (context,
                  {required currentLength, required isFocused, maxLength}) {
                if (!widget.enableCounterText) return null;
                int length =
                    VoceTextInputFormatter.bytesLength(widget.controller.text);

                return Text(
                  '$length/$maxLength',
                  style: Theme.of(context).textTheme.caption,
                );
                // }
              },
              inputFormatters: [VoceTextInputFormatter(_maxLength!)],
              maxLength: _maxLength,
              controller: widget.controller,
              focusNode: widget.focusNode,
              autocorrect: false,
              autofocus: true,
              obscureText: widget.obscureText,
              textInputAction: widget.textInputAction,
              textAlignVertical: TextAlignVertical.center,
              onSubmitted: widget.onSubmitted,
              onChanged: widget.onChanged,
              scrollPadding: widget.scrollPadding,
              style: TextStyle(
                fontSize: widget.fontSize,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        if (widget.footer != null) const SizedBox(height: 4),
        if (widget.footer != null) widget.footer!
      ],
    );
  }
}
