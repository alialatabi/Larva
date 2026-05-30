import 'package:flutter/material.dart';

/// Tappable wrapper with 0.96 scale press feedback.
/// Satisfies ui-ux-pro-max rule: scale-feedback + press-feedback (80–150ms visual response).
class Pressable extends StatefulWidget {
  const Pressable({
    super.key,
    required this.onTap,
    required this.child,
    this.onLongPress,
    this.semanticLabel,
    this.enabled = true,
  });

  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Widget child;
  final String? semanticLabel;
  final bool enabled;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onTapDown(_) {
    if (widget.enabled) _ctrl.forward();
  }

  void _onTapUp(_) => _ctrl.reverse();
  void _onTapCancel() => _ctrl.reverse();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semanticLabel,
      button: widget.semanticLabel != null,
      child: GestureDetector(
        onTap: widget.enabled ? widget.onTap : null,
        onLongPress: widget.onLongPress,
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        behavior: HitTestBehavior.opaque,
        child: ScaleTransition(scale: _scale, child: widget.child),
      ),
    );
  }
}
