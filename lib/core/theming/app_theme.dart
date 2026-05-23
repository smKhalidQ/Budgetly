import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const primaryColor = Color(0xff082659);
const secondaryColor = Color(0xff51eec2);

final appTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      centerTitle: true,
    ),
    brightness: Brightness.light,
    primaryColor: primaryColor,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(color: primaryColor),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: secondaryColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
        floatingLabelStyle: const TextStyle(color: primaryColor),
        iconColor: secondaryColor,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: secondaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: primaryColor),
          borderRadius: BorderRadius.circular(8),
        )));

final innerColor = Color.fromRGBO(233, 242, 249, 1);
final shadowColor = Color.fromRGBO(220, 227, 234, 1);

const greenGradient = [
  Color.fromRGBO(223, 250, 92, 1),
  Color.fromRGBO(129, 250, 112, 1)
];
const turqoiseGradient = [
  Color.fromRGBO(91, 253, 199, 1),
  Color.fromRGBO(129, 182, 205, 1)
];
const redGradient = [
  Color.fromRGBO(255, 93, 91, 1),
  Color.fromRGBO(254, 154, 92, 1),
];
const orangeGradient = [
  Color.fromRGBO(251, 173, 86, 1),
  Color.fromRGBO(253, 255, 93, 1),
];

final color1 = Color(0xFF23215B);
final color2 = Color(0xFF567DF4);
final color3 = Color(0xFFFFC700);
final color4 = Color(0XFF4DE364);

final walletColor = Color(0xFFF3F6FD);
final transferColor = Color(0xFFFFF9E5);
final voucherColor = Color(0xFFF0EFF4);
final billColor = Color(0xFFEDFCF0);

final userNameTextStyle = GoogleFonts.montserrat(
    fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18);
final helloTextStyle = GoogleFonts.montserrat(color: Colors.grey[100]);
final cardAmountTextStyle = GoogleFonts.montserrat(
    fontSize: 28, fontWeight: FontWeight.bold, color: color1);
final transactionAmountTextStyle = GoogleFonts.montserrat(
    fontSize: 15, fontWeight: FontWeight.bold, color: color1);
final transactionTextStyle = GoogleFonts.montserrat(
    fontSize: 16, fontWeight: FontWeight.bold, color: color1);
final transactionDateTextStyle = GoogleFonts.montserrat(
    fontSize: 13, fontWeight: FontWeight.w100, color: Colors.black);
final serviceLabelStyle =
    GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.bold);
