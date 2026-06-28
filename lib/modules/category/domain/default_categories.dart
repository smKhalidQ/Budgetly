import 'package:flutter/material.dart';
import 'models/category.dart' show Category;

final List<Category> defaultCategories = [
  Category(
    id: 1,
    name: 'Housing',
    color: 'Color(0xff1565c0)',
    icon: Icons.home_rounded.codePoint.toString(),
    allocatedAmount: 0,
  ),
  Category(
    id: 2,
    name: 'Food & Drinks',
    color: 'Color(0xfff57c00)',
    icon: Icons.restaurant_rounded.codePoint.toString(),
    allocatedAmount: 0,
  ),
  Category(
    id: 3,
    name: 'Transportation',
    color: 'Color(0xff546e7a)',
    icon: Icons.directions_car_rounded.codePoint.toString(),
    allocatedAmount: 0,
  ),
  Category(
    id: 4,
    name: 'Healthcare',
    color: 'Color(0xff2e7d32)',
    icon: Icons.medical_services_rounded.codePoint.toString(),
    allocatedAmount: 0,
  ),
  Category(
    id: 5,
    name: 'Entertainment',
    color: 'Color(0xff6a1b9a)',
    icon: Icons.sports_esports_rounded.codePoint.toString(),
    allocatedAmount: 0,
  ),
  Category(
    id: 6,
    name: 'Other',
    color: 'Color(0xff90a4ae)',
    icon: Icons.category_rounded.codePoint.toString(),
    allocatedAmount: 0,
  ),
  Category(
    id: 7,
    name: 'Saving & Goals',
    color: 'Color(0xfff9a825)',
    icon: Icons.savings_rounded.codePoint.toString(),
    allocatedAmount: 0,
  ),
];