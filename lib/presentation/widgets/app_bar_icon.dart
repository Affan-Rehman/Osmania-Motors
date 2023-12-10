import 'package:flutter/material.dart';

class AppBarIcon extends StatelessWidget {
  const AppBarIcon({
    Key? key,
    this.onTap,
    this.iconData,
    this.iconColor,
    this.borderColor,
  }) : super(key: key);
  final VoidCallback? onTap;
  final IconData? iconData;
  final Color? iconColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 0.5, color: borderColor ?? Colors.grey),
        ),
        child: GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: Icon(
              iconData,
              color: iconColor ?? Colors.grey,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
