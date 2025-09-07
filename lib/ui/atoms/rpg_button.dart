import 'package:flutter/material.dart';

enum RPGButtonType {
  primary,
  secondary,
  outlined,
  text,
}

class RPGButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final RPGButtonType type;
  final bool isLoading;
  final double? width;
  final double height;
  final IconData? icon;
  final bool withMicroInteraction;

  const RPGButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = RPGButtonType.primary,
    this.isLoading = false,
    this.width,
    this.height = 50,
    this.icon,
    this.withMicroInteraction = true,
  });

  @override
  State<RPGButton> createState() => _RPGButtonState();
}

class _RPGButtonState extends State<RPGButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    Widget buttonChild = widget.isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: 18),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  widget.text,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _getTextColor(),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );

    Widget button = SizedBox(
      width: widget.width,
      height: widget.height,
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: _getButtonStyle(),
        child: buttonChild,
      ),
    );

    if (widget.withMicroInteraction) {
      return GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: _isPressed ? 0.98 : 1.0,
          duration: const Duration(milliseconds: 80),
          curve: Curves.easeOut,
          child: button,
        ),
      );
    }

    return button;
  }

  ButtonStyle _getButtonStyle() {
    switch (widget.type) {
      case RPGButtonType.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
        );
      case RPGButtonType.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[800],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
        );
      case RPGButtonType.outlined:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          side: const BorderSide(color: Colors.amber, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        );
      case RPGButtonType.text:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );
    }
  }

  Color _getTextColor() {
    switch (widget.type) {
      case RPGButtonType.primary:
        return Colors.black;
      case RPGButtonType.secondary:
        return Colors.white;
      case RPGButtonType.outlined:
        return Colors.amber;
      case RPGButtonType.text:
        return Colors.amber;
    }
  }
}
