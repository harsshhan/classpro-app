import 'package:flutter/material.dart';

class TextStyles {
  static const TextStyle userDetailQn = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Color.fromRGBO(90, 91, 94, 1)
  );
  static const TextStyle userDetailAns = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white
  );

}


class AppColors {
  static const Color darkColor = Color.fromRGBO(10, 12, 16, 1); 
  static const Color darkTransparent = Color.fromRGBO(10, 12, 16, 0); 
  static const Color bgColor = Color.fromRGBO(9, 11, 17, 1);
  static const Color tot_marks_bgColor = Color.fromRGBO(204, 204, 205, 1);

  

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomRight,
    colors: [darkColor, darkTransparent],
  );
}