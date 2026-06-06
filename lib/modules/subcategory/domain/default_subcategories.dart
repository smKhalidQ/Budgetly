import 'package:budget_buddy/modules/category/domain/models/category.dart';
import 'package:budget_buddy/modules/subcategory/domain/models/subcategory.dart';
import 'package:flutter/material.dart';

/// Returns default subcategories for a category.
/// Each subcategory inherits the parent category's color.
List<Subcategory> getDefaultSubcategories(Category category) {
  final entries = _defaultEntries[category.id];
  if (entries == null || entries.isEmpty) return [];

  return entries
      .map((e) => Subcategory(
            name: e.$1,
            icon: e.$2.codePoint.toString(),
            color: category.color,
            spentAmount: '0',
          ))
      .toList();
}

// (name, icon) tuples per default category id
const Map<int, List<(String, IconData)>> _defaultEntries = {
  1: [ // Housing
    ('Rent',         Icons.home_rounded),
    ('Utilities',    Icons.bolt_rounded),
    ('Internet',     Icons.wifi_rounded),
    ('Maintenance',  Icons.build_rounded),
    ('Furniture',    Icons.chair_rounded),
  ],
  2: [ // Food & Drinks
    ('Restaurants',  Icons.restaurant_rounded),
    ('Groceries',    Icons.local_grocery_store_rounded),
    ('Coffee',       Icons.coffee_rounded),
    ('Snacks',       Icons.fastfood_rounded),
    ('Delivery',     Icons.delivery_dining_rounded),
  ],
  3: [ // Transportation
    ('Fuel',         Icons.local_gas_station_rounded),
    ('Public Transit', Icons.directions_bus_rounded),
    ('Parking',      Icons.local_parking_rounded),
    ('Taxi / Ride',  Icons.local_taxi_rounded),
    ('Car Service',  Icons.car_repair_rounded),
  ],
  4: [ // Healthcare
    ('Doctor',       Icons.medical_services_rounded),
    ('Medicine',     Icons.medication_rounded),
    ('Gym',          Icons.fitness_center_rounded),
    ('Dentist',      Icons.sentiment_satisfied_rounded),
    ('Pharmacy',     Icons.local_pharmacy_rounded),
  ],
  5: [ // Entertainment
    ('Movies',       Icons.movie_rounded),
    ('Gaming',       Icons.sports_esports_rounded),
    ('Streaming',    Icons.play_circle_rounded),
    ('Books',        Icons.menu_book_rounded),
    ('Events',       Icons.celebration_rounded),
  ],
  6: [ // Other
    ('Shopping',     Icons.shopping_bag_rounded),
    ('Gifts',        Icons.card_giftcard_rounded),
    ('Subscriptions', Icons.subscriptions_rounded),
    ('Personal Care', Icons.spa_rounded),
    ('Education',    Icons.school_rounded),
  ],
  7: [ // Saving
    ('Emergency Fund', Icons.shield_rounded),
    ('Investment',   Icons.trending_up_rounded),
    ('Travel Fund',  Icons.flight_rounded),
    ('Retirement',   Icons.beach_access_rounded),
  ],
};
