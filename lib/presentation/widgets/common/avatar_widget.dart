import 'package:flutter/material.dart';
import 'package:kiponnect/core/constants/app_colors.dart';

class AvatarWidget extends StatelessWidget {
  final String? imageUrl;
  final String initials;
  final double size;
  final BorderRadiusGeometry? borderRadius;
  final bool showOnlineIndicator;
  final bool isOnline;

  const AvatarWidget({
    Key? key,
    this.imageUrl,
    required this.initials,
    this.size = 48,
    this.borderRadius,
    this.showOnlineIndicator = false,
    this.isOnline = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.primaryOrange,
            borderRadius: borderRadius ?? BorderRadius.circular(size / 2),
            image: imageUrl != null
                ? DecorationImage(
                    image: NetworkImage(imageUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: imageUrl == null
              ? Center(
                  child: Text(
                    initials,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                )
              : null,
        ),
        if (showOnlineIndicator)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: size * 0.3,
              height: size * 0.3,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isOnline ? AppColors.successGreen : AppColors.textTertiary,
                border: Border.all(color: AppColors.darkSurface, width: 2),
              ),
            ),
          ),
      ],
    );
  }
}
