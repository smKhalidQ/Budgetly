import 'package:budget_buddy/l10n/app_localizations.dart';
import 'package:budget_buddy/modules/subcategory/domain/models/subcategory.dart';

extension SubcategoryLocalization on Subcategory {
  String localizedName(AppLocalizations t) {
    return switch (name) {
      'Rent' => t.rent,
      'Utilities' => t.utilities,
      'Internet' => t.internet,
      'Maintenance' => t.maintenance,
      'Furniture' => t.furniture,
      'Restaurants' => t.restaurants,
      'Groceries' => t.groceries,
      'Coffee' => t.coffee,
      'Snacks' => t.snacks,
      'Delivery' => t.delivery,
      'Fuel' => t.fuel,
      'Public Transit' => t.publicTransit,
      'Parking' => t.parking,
      'Taxi / Ride' => t.taxiRide,
      'Car Service' => t.carService,
      'Doctor' => t.doctor,
      'Medicine' => t.medicine,
      'Gym' => t.gym,
      'Dentist' => t.dentist,
      'Pharmacy' => t.pharmacy,
      'Movies' => t.movies,
      'Gaming' => t.gaming,
      'Streaming' => t.streaming,
      'Books' => t.books,
      'Events' => t.events,
      'Shopping' => t.shopping,
      'Gifts' => t.gifts,
      'Subscriptions' => t.subscriptions,
      'Personal Care' => t.personalCare,
      'Education' => t.education,
      'Emergency Fund' => t.emergencyFund,
      'Investment' => t.investment,
      'Travel Fund' => t.travelFund,
      'Retirement' => t.retirement,
      _ => name,
    };
  }
}
