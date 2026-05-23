import 'package:flutter/material.dart';

Map<String, Map<String, String>> currencies = {
  "OMR": {"currencyName": "Omani Rial", "currencySymbol": "﷼", "flag": "🇴🇲"},
  "TRY": {"currencyName": "Turkish Lira", "currencySymbol": "₺", "flag": "🇹🇷"},
  "EGP": {"currencyName": "Egyptian Pound", "currencySymbol": "£", "flag": "🇪🇬"},
  "QAR": {"currencyName": "Qatari Riyal", "currencySymbol": "﷼", "flag": "🇶🇦"},
  "KWD": {"currencyName": "Kuwaiti Dinar", "currencySymbol": "د.ك", "flag": "🇰🇼"},
  "USD": {"currencyName": "United States Dollar", "currencySymbol": "\$", "flag": "🇺🇸"},
  "EUR": {"currencyName": "Euro", "currencySymbol": "€", "flag": "🇪🇺"},
  "JPY": {"currencyName": "Japanese Yen", "currencySymbol": "¥", "flag": "🇯🇵"},
  "BRL": {"currencyName": "Brazilian Real", "currencySymbol": "R\$", "flag": "🇧🇷"},
  "SAR": {"currencyName": "Saudi Riyal", "currencySymbol": "﷼", "flag": "🇸🇦"},
};

List<String> iconImages = [
  "assets/housing.png",
  "assets/saving.png",
  "assets/transportation.png",
  "assets/entertainment.png",
  "assets/healthcare.png",
  "assets/food&drink.png",
];

Color parseColorFromString(String colorString) {
  try {
    colorString = colorString.replaceAll("Color(", "").replaceAll(")", "");
    if (colorString.startsWith('0x')) {
      return Color(int.parse(colorString));
    } else if (colorString.startsWith('MaterialAccent')) {
      return Colors.blueAccent;
    } else {
      return Color(int.parse('0xff${colorString.padLeft(6, '0')}'));
    }
  } catch (e) {
    return Colors.blue;
  }
}
