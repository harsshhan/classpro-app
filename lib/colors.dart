import 'package:flutter/material.dart';

class AppColors {
  static const Color darkColor = Color.fromRGBO(10, 12, 16, 1); 
  static const Color darkTransparent = Color.fromRGBO(10, 12, 16, 0); 
  static const Color bgColor = Color.fromRGBO(9, 11, 17, 1);
  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomRight,
    colors: [darkColor, darkTransparent],
  );
}