import 'package:flutter/material.dart';
import 'models/category.dart' show Category;

// Colors below are drawn from AppColor.categoryPalette (kept as literal
// hex here since Category.color is stored as a plain string).
final List<Category> defaultCategories = [
  Category(
    id: 1,
    name: 'Housing',
    color: 'Color(0xff3b566d)', // slate blue
    icon: Icons.home_rounded.codePoint.toString(),
    allocatedAmount: 0,
  ),
  Category(
    id: 2,
    name: 'Food & Drinks',
    color: 'Color(0xffe0a458)', // muted amber
    icon: Icons.restaurant_rounded.codePoint.toString(),
    allocatedAmount: 0,
  ),
  Category(
    id: 3,
    name: 'Transportation',
    color: 'Color(0xff90a4ae)', // blue-grey
    icon: Icons.directions_car_rounded.codePoint.toString(),
    allocatedAmount: 0,
  ),
  Category(
    id: 4,
    name: 'Healthcare',
    color: 'Color(0xff52a07d)', // sage green
    icon: Icons.medical_services_rounded.codePoint.toString(),
    allocatedAmount: 0,
  ),
  Category(
    id: 5,
    name: 'Entertainment',
    color: 'Color(0xff9b6cef)', // muted violet
    icon: Icons.sports_esports_rounded.codePoint.toString(),
    allocatedAmount: 0,
  ),
  Category(
    id: 6,
    name: 'Other',
    color: 'Color(0xff90a4ae)', // blue-grey
    icon: Icons.category_rounded.codePoint.toString(),
    allocatedAmount: 0,
  ),
  Category(
    id: 7,
    name: 'Saving & Goals',
    color: 'Color(0xff4f959d)', // teal
    icon: Icons.savings_rounded.codePoint.toString(),
    allocatedAmount: 0,
  ),
];