import 'package:flutter/material.dart';
import 'package:kiponnect/core/constants/app_colors.dart';

class KiponnectCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final double borderRadius;
  final Border? border;
  final BoxShadow? shadow;

  const KiponnectCard({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.backgroundColor,
    this.borderRadius = 20,
    this.border,
    this.shadow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.darkSurface,
          borderRadius: BorderRadius.circular(borderRadius),
          border: border,
          boxShadow: shadow != null ? [shadow!] : null,
        ),
        child: child,
      ),
    );
  }
}
