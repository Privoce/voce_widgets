library voce_widgets;

import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VoceTextField extends StatefulWidget {
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
                int utf8Length = utf8.encode(widget.controller.text).length;
                if (currentLength > 0 && utf8Length > 1) {
                  var twoCharsLength = utf8Length - currentLength;
                  return Text(
                    '$twoCharsLength/$maxLength',
                    style: Theme.of(context).textTheme.caption,
                  );
                } else {
                  return Text(
                    '$utf8Length/$maxLength',
                    style: Theme.of(context).textTheme.caption,
                  );
                }
              },
              inputFormatters: [
                _Utf8LengthLimitingTextInputFormatter(_maxLength!)
              ],
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
      ],
    );
  }
}

class _Utf8LengthLimitingTextInputFormatter extends TextInputFormatter {
  _Utf8LengthLimitingTextInputFormatter(this.maxLength)
      : assert(maxLength == null || maxLength == -1 || maxLength > 0);

  final int maxLength;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (maxLength != null &&
        maxLength > 0 &&
        bytesLength(newValue.text) > maxLength) {
      // If already at the maximum and tried to enter even more, keep the old value.
      if (bytesLength(oldValue.text) == maxLength) {
        return oldValue;
      }
      return truncate(newValue, maxLength);
    }
    return newValue;
  }

  static TextEditingValue truncate(TextEditingValue value, int maxLength) {
    var newValue = '';
    if (bytesLength(value.text) > maxLength) {
      var length = 0;

      value.text.characters.takeWhile((char) {
        var nbBytes = bytesLength(char);

        if (length + nbBytes <= maxLength) {
          newValue += char;

          length += nbBytes;
          return true;
        }
        return false;
      });
    }
    return TextEditingValue(
      text: newValue,
      selection: value.selection.copyWith(
        baseOffset: min(value.selection.start, newValue.length),
        extentOffset: min(value.selection.end, newValue.length),
      ),
      composing: TextRange.empty,
    );
  }

  static int bytesLength(String value) {
    var twoCharsLength = utf8.encode(value).length - 1;
    return twoCharsLength;
  }
}
