import 'dart:ui';

class DrawerItemModel {
  final String title;
  final String icon;
  final double width;
  final VoidCallback onTap;

  DrawerItemModel({
    required this.title,
    required this.icon,
    required this.width,
    required this.onTap,
  });
}
