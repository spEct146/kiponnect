import 'package:flutter/material.dart';
import 'package:kiponnect/core/constants/app_colors.dart';

class CutoutNavBarPainter extends CustomPainter {
  final int activeIndex;
  final int itemCount;
  final double cutoutRadius;
  final double glow;

  CutoutNavBarPainter({
    required this.activeIndex,
    required this.itemCount,
    this.cutoutRadius = 40,
    this.glow = 50,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.darkSurface
      ..style = PaintingStyle.fill;

    final glowPaint = Paint()
      ..color = AppColors.primaryOrange.withOpacity(0.3)
      ..maskFilter = MaskFilter.blur(BlurStyle.outer, 8);

    // Calculate the position of the cutout based on active index
    final itemWidth = size.width / itemCount;
    final centerX = (activeIndex + 0.5) * itemWidth;
    final centerY = 0.0;

    // Create path for the nav bar with cutout
    final path = Path();

    // Start from bottom left
    path.moveTo(0, size.height);

    // Bottom line to before cutout
    path.lineTo(centerX - cutoutRadius, size.height);

    // Cutout arc (concave, going upward)
    path.arcToPoint(
      Offset(centerX + cutoutRadius, size.height),
      radius: Radius.circular(cutoutRadius),
      largeArc: false,
      clockwise: false,
    );

    // Bottom right to top right
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height - 20); // Slight rounded top
    path.quadraticBezierTo(size.width, 0, size.width - 20, 0);

    // Top right to top left
    path.lineTo(20, 0);
    path.quadraticBezierTo(0, 0, 0, size.height - 20);

    // Close path
    path.close();

    // Draw glow effect
    canvas.drawPath(path, glowPaint);

    // Draw main nav bar
    canvas.drawPath(path, paint);

    // Optional: Draw a subtle border
    final borderPaint = Paint()
      ..color = AppColors.borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(CutoutNavBarPainter oldDelegate) {
    return oldDelegate.activeIndex != activeIndex;
  }
}

class KiponnectBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<NavBarItem> items;
  final Color backgroundColor;
  final Color activeColor;
  final Color inactiveColor;

  const KiponnectBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.backgroundColor = AppColors.darkSurface,
    this.activeColor = AppColors.primaryOrange,
    this.inactiveColor = AppColors.textSecondary,
  }) : super(key: key);

  @override
  State<KiponnectBottomNavBar> createState() => _KiponnectBottomNavBarState();
}

class _KiponnectBottomNavBarState extends State<KiponnectBottomNavBar>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.items.length,
      (index) => AnimationController(
        duration: Duration(milliseconds: 300),
        vsync: this,
      ),
    );
  }

  @override
  void didUpdateWidget(KiponnectBottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _controllers[oldWidget.currentIndex].reverse();
      _controllers[widget.currentIndex].forward();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: Stack(
        children: [
          // Custom painted nav bar
          CustomPaint(
            painter: CutoutNavBarPainter(
              activeIndex: widget.currentIndex,
              itemCount: widget.items.length,
            ),
            size: Size(MediaQuery.of(context).size.width, 80),
          ),
          // Nav items
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(
                widget.items.length,
                (index) {
                  final isActive = index == widget.currentIndex;
                  return _NavBarItemWidget(
                    item: widget.items[index],
                    isActive: isActive,
                    onTap: () => widget.onTap(index),
                    controller: _controllers[index],
                    activeColor: widget.activeColor,
                    inactiveColor: widget.inactiveColor,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NavBarItem {
  final IconData icon;
  final String label;
  final Widget? customIcon;

  NavBarItem({
    required this.icon,
    required this.label,
    this.customIcon,
  });
}

class _NavBarItemWidget extends StatelessWidget {
  final NavBarItem item;
  final bool isActive;
  final VoidCallback onTap;
  final AnimationController controller;
  final Color activeColor;
  final Color inactiveColor;

  const _NavBarItemWidget({
    required this.item,
    required this.isActive,
    required this.onTap,
    required this.controller,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          final scale = 1.0 + (controller.value * 0.2);
          return Transform.scale(
            scale: scale,
            child: ScaleTransition(
              scale: Tween<double>(begin: 1.0, end: 1.15).animate(
                CurvedAnimation(parent: controller, curve: Curves.easeInOut),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive
                          ? activeColor.withOpacity(0.15)
                          : Colors.transparent,
                    ),
                    child: Icon(
                      item.icon,
                      color: isActive ? activeColor : inactiveColor,
                      size: 24,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    item.label,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: isActive ? activeColor : inactiveColor,
                          fontSize: 10,
                        ),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
