import 'package:flutter/material.dart';

class FunctionIcon extends StatelessWidget {
  final onPressed;
  final Icon icon;
  final bool primary;
  final String tooltip;
  const FunctionIcon(this.onPressed, this.icon, this.primary, this.tooltip);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: primary ? Theme.of(context).primaryColor : Colors.white,
      icon: icon,
      tooltip: tooltip,
      onPressed: onPressed,
    );
  }
}
