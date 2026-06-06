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
    colorString = colorString.replaceAll("Color(", "").replaceAll(")", "").trim();
    int value;
    if (colorString.startsWith('0x') || colorString.startsWith('0X')) {
      value = int.parse(colorString);
    } else if (colorString.startsWith('MaterialAccent')) {
      return Colors.blueAccent;
    } else {
      value = int.parse('0xff${colorString.padLeft(6, '0')}');
    }
    return Color.fromARGB(
      (value >> 24) & 0xFF,
      (value >> 16) & 0xFF,
      (value >> 8) & 0xFF,
      value & 0xFF,
    );
  } catch (_) {
    return const Color(0xff2196f3);
  }
}
