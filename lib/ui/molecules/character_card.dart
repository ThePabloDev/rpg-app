import 'package:flutter/material.dart';
import '../atoms/app_colors.dart';
import '../atoms/text_atom.dart';
import '../atoms/icon_atom.dart';

class CharacterCard extends StatefulWidget {
  final String name;
  final String subtitle;
  final String avatarUrl; // pode ser placeholder
  final VoidCallback? onTap;
  final VoidCallback? onAction;

  const CharacterCard({
    Key? key,
    required this.name,
    required this.subtitle,
    this.avatarUrl = '',
    this.onTap,
    this.onAction,
  }) : super(key: key);

  @override
  _CharacterCardState createState() => _CharacterCardState();
}

class _CharacterCardState extends State<CharacterCard> {
  bool _pressed = false;

  void _setPressed(bool v) => setState(() => _pressed = v);

  @override
  Widget build(BuildContext context) {
    final elevation = _pressed ? 8.0 : 2.0;
    final scale = _pressed ? 0.995 : 1.0;

    return Semantics(
      container: true,
      label: 'Card do personagem ${widget.name}',
      child: GestureDetector(
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) {
          _setPressed(false);
          widget.onTap?.call();
        },
        onTapCancel: () => _setPressed(false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          transform: Matrix4.identity()..scale(scale),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: AppColors.cardShadow, blurRadius: elevation, offset: const Offset(0, elevation / 2)),
            ],
          ),
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            children: [
              // avatar
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Text(
                  widget.name.isNotEmpty ? widget.name[0].toUpperCase() : '?',
                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              // texts
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextAtom(widget.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    TextAtom(widget.subtitle, style: const TextStyle(color: AppColors.textLow, fontSize: 13)),
                  ],
                ),
              ),
              // action icon
              IconAtom(
                icon: Icons.arrow_forward_ios,
                semanticsLabel: 'Abrir ${widget.name}',
                onTap: widget.onAction,
                size: 18,
                color: AppColors.textLow,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
