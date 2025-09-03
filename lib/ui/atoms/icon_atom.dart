import 'package:flutter/material.dart';
import 'app_colors.dart';

class IconAtom extends StatefulWidget {
  final IconData icon;
  final String? semanticsLabel;
  final VoidCallback? onTap;
  final Color? color;
  final double size;

  const IconAtom({
    Key? key,
    required this.icon,
    this.semanticsLabel,
    this.onTap,
    this.color,
    this.size = 20,
  }) : super(key: key);

  @override
  _IconAtomState createState() => _IconAtomState();
}

class _IconAtomState extends State<IconAtom> with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  void _onTapDown(_) => setState(() => _scale = 0.88);
  void _onTapUp(_) => setState(() => _scale = 1.0);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.semanticsLabel,
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: _onTapDown,
        onTapCancel: () => setState(() => _scale = 1.0),
        onTapUp: _onTapUp,
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: Icon(widget.icon, color: widget.color ?? AppColors.primary, size: widget.size),
        ),
      ),
    );
  }
}
