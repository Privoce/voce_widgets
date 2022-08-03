library voce_widgets;

import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_emoji/flutter_emoji.dart';

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
      this.title,
      this.enableCounterText = false})
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
                if (!widget.enableCounterText) return null;
                int length = _Utf8LengthLimitingTextInputFormatter.bytesLength(
                    widget.controller.text);

                return Text(
                  '$length/$maxLength',
                  style: Theme.of(context).textTheme.caption,
                );
                // }
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
      : assert(maxLength == -1 || maxLength > 0);

  final int maxLength;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (maxLength > 0 && bytesLength(newValue.text) > maxLength) {
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
    // var twoCharsLength = utf8.encode(value).length - 1;
    // return twoCharsLength;

    int count = 0;

    final charIterator = value.characters.iterator;
    while (charIterator.moveNext()) {
      final char = charIterator.current;

      if (isEmoji(char) || isCJK(char)) {
        count += 2;
      } else {
        count += 1;
      }
    }
    return count;
  }

  static bool isCJK(String char) {
    String p =
        r"\p{Script=Han}|\p{Script=Hiragana}|\p{Script=Katakana}|\p{Script=Hangul}|\p{Script=Arabic}";
    String punctuation = "[\u3000-\u303F]";
    String chinesePunc =
        '[＂＃＄％＆\'\'（）＊＋，－／：；＜＝＞＠［＼］＾＿｀｛｜｝～｟｠｢｣､、〃》「」『』【】〔〕〖〗〘〙〚〛〜〝〞〟〰〾〿–—‛„‟…‧﹏！？｡。]';

    return RegExp(p, unicode: true).hasMatch(char) ||
        RegExp(punctuation, unicode: true).hasMatch(char) ||
        RegExp(chinesePunc, unicode: true).hasMatch(char);
  }

  static bool isEmoji(String char) {
    var parser = EmojiParser();
    return parser.hasEmoji(char);
  }
}
