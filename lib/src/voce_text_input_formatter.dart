import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_emoji/flutter_emoji.dart';

class VoceTextInputFormatter extends TextInputFormatter {
  VoceTextInputFormatter(this.maxLength)
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
