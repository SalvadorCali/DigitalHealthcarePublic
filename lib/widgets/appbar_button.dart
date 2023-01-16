import 'package:flutter/material.dart';

class AppBarButton extends StatelessWidget {
  final Icon icon;
  final callback;
  AppBarButton(this.icon, this.callback);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: icon,
      onPressed: callback,
    );
  }
}
