import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum ButtonStatus { normal, busy, disabled }

class VoceButton extends StatefulWidget {
  /// The button widget in normal state.
  late final Widget normal;

  /// The button widget when async function is executing and
  /// the system is awaiting.
  final Widget? busy;

  /// The button widget when it is disabled.
  final Widget? disabled;

  final bool filled;

  /// The async function to be executed when button is pressed.
  final Future<bool> Function() action;

  final double pressedOpacity;

  final VoidCallback? onSuccess;
  final VoidCallback? onError;

  final bool keepNormalWhenBusy;

  final double? height;
  final double? width;
  late BoxDecoration? decoration;
  final EdgeInsets? contentPadding;

  /// ValueNotifier for button status.
  /// Status include [ButtonStatus.normal], [ButtonStatus.busy],
  /// [ButtonStatus.disabled] and [ButtonStatus.beingTapped].
  late final ValueNotifier<ButtonStatus> _btnStatus;

  VoceButton(
      {Key? key,
      required this.normal,
      this.busy,
      this.disabled,
      this.filled = false,
      required this.action,
      this.pressedOpacity = 0.4,
      this.onSuccess,
      this.onError,
      this.height,
      this.width,
      this.decoration,
      this.contentPadding,
      ValueNotifier<bool>? enabled,
      this.keepNormalWhenBusy = true})
      : super(key: key) {
    assert(pressedOpacity >= 0.0 && pressedOpacity <= 1.0);

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
  State<VoceButton> createState() => _VoceButtonState();
}

class _VoceButtonState extends State<VoceButton>
    with SingleTickerProviderStateMixin {
  static const Duration kFadeOutDuration = Duration(milliseconds: 120);
  static const Duration kFadeInDuration = Duration(milliseconds: 180);
  final Tween<double> _opacityTween = Tween<double>(begin: 1.0);

  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      value: 0.0,
      vsync: this,
    );
    _opacityAnimation = _animationController
        .drive(CurveTween(curve: Curves.decelerate))
        .drive(_opacityTween);
    _setTween();
  }

  @override
  void didUpdateWidget(VoceButton old) {
    super.didUpdateWidget(old);
    _setTween();
  }

  void _setTween() {
    _opacityTween.end = widget.pressedOpacity;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool _buttonHeldDown = false;

  void _handleTapDown(TapDownDetails event) {
    if (!_buttonHeldDown) {
      _buttonHeldDown = true;
      _animate();
    }
  }

  void _handleTapUp(TapUpDetails event) {
    if (_buttonHeldDown) {
      _buttonHeldDown = false;
      _animate();
    }
  }

  void _handleTapCancel() {
    if (_buttonHeldDown) {
      _buttonHeldDown = false;
      _animate();
    }
  }

  void _animate() {
    if (_animationController.isAnimating) return;
    final bool wasHeldDown = _buttonHeldDown;
    final TickerFuture ticker = _buttonHeldDown
        ? _animationController.animateTo(1.0,
            duration: kFadeOutDuration, curve: Curves.easeInOutCubicEmphasized)
        : _animationController.animateTo(0.0,
            duration: kFadeInDuration, curve: Curves.easeOutCubic);
    ticker.then<void>((void value) {
      if (mounted && wasHeldDown != _buttonHeldDown) _animate();
    });
  }

  @override
  Widget build(BuildContext context) {
    final CupertinoThemeData themeData = CupertinoTheme.of(context);
    final Color primaryColor = themeData.primaryColor;
    final TextStyle defaultTextStyle =
        themeData.textTheme.textStyle.copyWith(color: primaryColor);

    return ValueListenableBuilder(
        valueListenable: widget._btnStatus,
        builder: ((context, status, child) {
          List<Widget> children;

          switch (status) {
            case ButtonStatus.normal:
              children = [widget.normal];
              break;
            case ButtonStatus.busy:
              if (widget.busy != null) {
                children = [widget.busy!];
              } else {
                if (widget.keepNormalWhenBusy) {
                  children = [
                    CupertinoActivityIndicator(color: primaryColor),
                    const SizedBox(width: 16),
                    widget.normal
                  ];
                } else {
                  children = [
                    CupertinoActivityIndicator(color: primaryColor),
                  ];
                }
              }
              break;
            case ButtonStatus.disabled:
              children = [widget.normal];
              break;
            default:
              children = [widget.normal];
              break;
          }

          Widget button = Container(
              height: widget.height ?? 40,
              width: widget.width,
              decoration: widget.decoration ??
                  BoxDecoration(borderRadius: BorderRadius.circular(8)),
              padding: widget.contentPadding ?? const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: children,
              ));

          if (status == ButtonStatus.disabled) {
            button = widget.disabled ??
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
                    child: button);
          }

          bool enabled = status == ButtonStatus.normal;
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: enabled ? _handleTapDown : null,
            onTapUp: enabled ? _handleTapUp : null,
            onTapCancel: enabled ? _handleTapCancel : null,
            onTap: onPressed,
            child: FadeTransition(
                opacity: _opacityAnimation,
                child:
                    DefaultTextStyle(style: defaultTextStyle, child: button)),
          );
        }));
  }

  void onPressed() {
    if (widget._btnStatus.value == ButtonStatus.normal) {
      executeAsyncAction();
    }
  }

  void executeAsyncAction() async {
    widget._btnStatus.value = ButtonStatus.busy;

    final result = await widget.action();

    if (result) {
      widget.onSuccess == null ? () {} : widget.onSuccess!();
    } else {
      widget.onError == null ? () {} : widget.onError!();
    }

    widget._btnStatus.value = ButtonStatus.normal;
  }
}
