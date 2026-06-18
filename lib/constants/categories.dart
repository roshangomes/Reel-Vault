import 'package:flutter/material.dart';

class ReelCategory {
  final String id;
  final String label;
  final IconData icon;
  final Color color;
  final String description;

  const ReelCategory({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
    required this.description,
  });

  Color get lightBg => color.withOpacity(0.12);
}

const List<ReelCategory> kCategories = [
  ReelCategory(
    id: 'visit',
    label: 'Want to visit',
    icon: Icons.place_outlined,
    color: Color(0xFF009688),
    description: 'Places you want to travel to',
  ),
  ReelCategory(
    id: 'watch',
    label: 'Want to watch',
    icon: Icons.play_circle_outline_rounded,
    color: Color(0xFF673AB7),
    description: 'Shows, movies and videos',
  ),
  ReelCategory(
    id: 'try',
    label: 'Want to try',
    icon: Icons.restaurant_outlined,
    color: Color(0xFFF57C00),
    description: 'Food, drinks and recipes',
  ),
  ReelCategory(
    id: 'learn',
    label: 'Want to learn',
    icon: Icons.lightbulb_outline_rounded,
    color: Color(0xFF1976D2),
    description: 'Skills and tutorials',
  ),
  ReelCategory(
    id: 'buy',
    label: 'Want to buy',
    icon: Icons.shopping_bag_outlined,
    color: Color(0xFFE91E63),
    description: 'Products to purchase',
  ),
  ReelCategory(
    id: 'do',
    label: 'Want to do',
    icon: Icons.directions_run_rounded,
    color: Color(0xFF388E3C),
    description: 'Activities and fitness',
  ),
];

ReelCategory categoryById(String id) => kCategories.firstWhere(
  (c) => c.id == id,
  orElse: () => kCategories.first,
);
