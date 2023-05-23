library voce_widgets;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voce_widgets/src/voce_text_input_formatter.dart';

class VoceTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool autofocus;
  final Function(String)? onSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool enableVisibleObscureText;
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
  final Color? disableColor;
  final double height;
  final int? maxLength;
  final InputDecoration? decoration;
  final bool enableCounterText;
  final String? hintText;
  final void Function(String)? onChanged;

  const VoceTextField(this.controller,
      {Key? key,
      this.focusNode,
      this.autofocus = false,
      this.onSubmitted,
      this.keyboardType,
      this.textInputAction,
      this.obscureText = false,
      this.enableVisibleObscureText = false,
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
      this.hintText,
      this.enabled = true})
      : _filled = false,
        color = null,
        disableColor = null,
        super(key: key);

  const VoceTextField.filled(this.controller,
      {Key? key,
      this.focusNode,
      this.autofocus = false,
      this.onSubmitted,
      this.keyboardType,
      this.textInputAction,
      this.obscureText = false,
      this.enableVisibleObscureText = false,
      this.enableMargin = true,
      this.enableDeco = true,
      this.borderRadius = 8,
      this.fontSize = 16,
      this.scrollPadding = const EdgeInsets.all(20.0),
      this.color,
      this.disableColor,
      this.height = 48,
      this.maxLength,
      this.decoration,
      this.onChanged,
      this.title,
      this.footer,
      this.enableCounterText = false,
      this.hintText,
      this.enabled = true})
      : _filled = true,
        super(key: key);

  @override
  State<VoceTextField> createState() => _VoceTextFieldState();
}

class _VoceTextFieldState extends State<VoceTextField> {
  int? _maxLength;

  ValueNotifier<bool> showObscureText = ValueNotifier(false);

  @override
  initState() {
    super.initState();
    _maxLength = widget.maxLength;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) widget.title!,
        if (widget.title != null) const SizedBox(height: 4),
        Container(
          decoration: widget.enableVisibleObscureText
              ? BoxDecoration(
                  color: widget.enabled
                      ? (widget.color ?? Colors.white)
                      : (widget.disableColor ?? Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(widget.borderRadius))
              : null,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ValueListenableBuilder<bool>(
                    valueListenable: showObscureText,
                    builder: (context, visible, _) {
                      return TextField(
                        enabled: widget.enabled,
                        keyboardType: widget.keyboardType,
                        decoration: widget.decoration ??
                            InputDecoration(
                                filled: widget._filled,
                                fillColor: widget.enabled
                                    ? (widget.color ?? Colors.white)
                                    : (widget.disableColor ??
                                        Colors.grey.shade300),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        widget.borderRadius),
                                    borderSide: BorderSide.none),
                                isCollapsed: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                hintText: widget.hintText,
                                hintMaxLines: 1),
                        buildCounter: (context,
                            {required currentLength,
                            required isFocused,
                            maxLength}) {
                          if (!widget.enableCounterText) return null;
                          int length = VoceTextInputFormatter.bytesLength(
                              widget.controller.text);

                          return Text(
                            '$length/$maxLength',
                            style: Theme.of(context).textTheme.caption,
                          );
                          // }
                        },
                        inputFormatters: _maxLength != null
                            ? [VoceTextInputFormatter(_maxLength!)]
                            : null,
                        maxLength: _maxLength,
                        controller: widget.controller,
                        focusNode: widget.focusNode,
                        autocorrect: false,
                        autofocus: widget.autofocus,
                        obscureText: widget.obscureText && !visible,
                        textInputAction: widget.textInputAction,
                        textAlignVertical: TextAlignVertical.center,
                        onSubmitted: widget.onSubmitted,
                        onChanged: widget.onChanged,
                        scrollPadding: widget.scrollPadding,
                        style: TextStyle(
                          fontSize: widget.fontSize,
                          fontWeight: FontWeight.w400,
                        ),
                      );
                    }),
              ),
              if (widget.obscureText && widget.enableVisibleObscureText)
                SizedBox(
                  width: 36,
                  child: ValueListenableBuilder<bool>(
                    valueListenable: showObscureText,
                    builder: (context, visible, child) {
                      return CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Icon(
                              visible ? Icons.visibility_off : Icons.visibility,
                              color:
                                  widget.enabled ? null : Colors.grey.shade300),
                          onPressed: () {
                            showObscureText.value = !showObscureText.value;
                          });
                    },
                  ),
                )
            ],
          ),
        ),
        if (widget.footer != null) const SizedBox(height: 4),
        if (widget.footer != null) widget.footer!
      ],
    );
  }
}
