import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum ButtonStatus { normal, busy, disabled, beingTapped }

class VoceButton extends StatelessWidget {
  /// The button widget in normal state.
  late final Widget normal;

  /// The button widget when async function is executing and
  /// the system is awaiting.
  final Widget? busy;

  /// The button widget when it is disabled.
  final Widget? disabled;

  /// The async function to be executed when button is pressed.
  final Future<bool> Function() action;

  final VoidCallback? onSuccess;
  final VoidCallback? onError;
  final BoxDecoration? decoration;
  final bool filled;
  final bool keepNormalWhenBusy;

  /// ValueNotifier for button status.
  /// Status include [ButtonStatus.normal], [ButtonStatus.busy],
  /// [ButtonStatus.disabled] and [ButtonStatus.beingTapped].
  late final ValueNotifier<ButtonStatus> _btnStatus;

  VoceButton(
      {Key? key,
      required this.normal,
      this.busy,
      this.disabled,
      required this.action,
      this.onSuccess,
      this.onError,
      this.decoration,
      ValueNotifier<bool>? enabled,
      this.filled = false,
      this.keepNormalWhenBusy = true})
      : super(key: key) {
    _btnStatus = ValueNotifier(ButtonStatus.normal);
    if (enabled == null || enabled.value) {
      _btnStatus.value = ButtonStatus.normal;
    } else {
      _btnStatus.value = ButtonStatus.disabled;
    }

    enabled?.addListener(() {
      if (enabled.value) {
        _btnStatus.value = ButtonStatus.normal;
      } else {
        _btnStatus.value = ButtonStatus.disabled;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget child = ValueListenableBuilder(
        valueListenable: _btnStatus,
        builder: ((context, value, child) {
          switch (value) {
            case ButtonStatus.normal:
              return normal;
            case ButtonStatus.busy:
              if (busy != null) {
                return busy!;
              } else {
                return keepNormalWhenBusy
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CupertinoActivityIndicator(),
                          const SizedBox(width: 16),
                          normal
                        ],
                      )
                    : const CupertinoActivityIndicator();
              }
            case ButtonStatus.disabled:
              return disabled ??
                  ColorFiltered(
                    colorFilter: const ColorFilter.matrix(<double>[
                      0.2126,
                      0.7152,
                      0.0722,
                      0,
                      0,
                      0.2126,
                      0.7152,
                      0.0722,
                      0,
                      0,
                      0.2126,
                      0.7152,
                      0.0722,
                      0,
                      0,
                      0,
                      0,
                      0,
                      1,
                      0,
                    ]),
                    child: normal,
                  );
              ;
            case ButtonStatus.beingTapped:
              return Opacity(opacity: 0.6, child: normal);
            default:
              return normal;
          }
        }));

    // void Function()? onPressed => () {
    //       if (_btnStatus.value == ButtonStatus.normal) {
    //         executeAsyncAction();
    //       }
    //     };

    if (filled) {
      return CupertinoButton.filled(onPressed: onPressed, child: child);
    }
    return CupertinoButton(onPressed: onPressed, child: child);
  }

  void onPressed() {
    if (_btnStatus.value == ButtonStatus.normal) {
      executeAsyncAction();
    }
  }

  void executeAsyncAction() async {
    _btnStatus.value = ButtonStatus.busy;

    final result = await action();

    if (result) {
      onSuccess == null ? () {} : onSuccess!();
    } else {
      onError == null ? () {} : onError!();
    }

    _btnStatus.value = ButtonStatus.normal;
  }
}
