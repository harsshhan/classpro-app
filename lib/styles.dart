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
  static const TextStyle courseName = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.white
  );
  static const TextStyle margin = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: Color.fromRGBO(179, 179, 209, 40)
  );
  static  TextStyle required = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.errorColor.withValues(alpha: 0.5),
  );
  static const marginValue = TextStyle(
  color: AppColors.infoColor,
  fontWeight: FontWeight.bold,
  fontSize: 15,
);
  static const requiredValue = TextStyle(
  color: AppColors.errorColor,
  fontWeight: FontWeight.bold,
  fontSize: 15,
);

}


class AppColors {
  static const Color darkColor = Color.fromRGBO(10, 12, 16, 1); 
  static const Color darkSiide = Color.fromRGBO(23,29,38, 1); 
  static const Color darkAccent = Color.fromRGBO(179,179,209, 1); 
  
  static const Color darkTransparent = Color.fromRGBO(10, 12, 16, 0); 
  static const Color bgColor = Color.fromRGBO(9, 11, 17, 1);
  static const Color tot_marks_bgColor = Color.fromRGBO(204, 204, 205, 1);


  static const backgroundDark = Color.fromRGBO(6,9,13,1);
  static const backgroundLight = Color.fromRGBO(30,35,43,1);


  static const theory = Color.fromRGBO(242, 216, 105, 1);
  static const practical = Color.fromRGBO(105, 224, 105, 1);
  static const warnBackground = Color.fromRGBO(43, 40, 31, 1);
  static const warnColor = Color.fromRGBO(255, 202, 99, 1);

  static const successBackground = Color.fromRGBO(17, 37, 32, 1);
  static const successColor = Color.fromRGBO(124, 235, 155, 1);

  static const infoBackground = Color.fromRGBO(27, 29, 43, 1);
  static const infoColor = Color.fromRGBO(124, 179, 235, 1);

  static const errorBackground = Color.fromRGBO(29, 12, 12, 1);
  static const errorColor = Color.fromRGBO(247, 91, 91, 1);

  static const totBackground = Color.fromRGBO(207, 208, 209, 1);
  static const totColor = Color.fromRGBO(6, 9, 13, 1);

  static const backgroundNormal = Color.fromRGBO(17 ,21 ,27,1);

  static const accentColor = Color.fromRGBO(179,179,209,1);


  
 



  

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomRight,
    colors: [darkColor, darkTransparent],
  );
}



// class AppColors {
//   static const backgroundNormal = Color.fromRGBO(17, 21, 27, 1);
//   static const backgroundLight = Color.fromRGBO(30, 35, 43, 1);
//   static const backgroundDark = Color.fromRGBO(6, 9, 13, 1);
//   static const backgroundDarker = Color.fromRGBO(4, 7, 11, 1);
//   static const input = Color.fromRGBO(255, 255, 255, 0.03);
//   static const button = Color.fromRGBO(18, 22, 27, 1);
//   static const side = Color.fromRGBO(23, 29, 38, 1);
//   static const accent = Color.fromRGBO(179, 179, 209, 1);
//   static const color = Color.fromRGBO(254, 254, 254, 1);

//   static const errorBackground = Color.fromRGBO(29, 12, 12, 1);
//   static const errorColor = Color.fromRGBO(247, 91, 91, 1);

//   static const warnBackground = Color.fromRGBO(43, 40, 31, 1);
//   static const warnColor = Color.fromRGBO(255, 202, 99, 1);

//   static const successBackground = Color.fromRGBO(17, 37, 32, 1);
//   static const successColor = Color.fromRGBO(124, 235, 155, 1);

//   static const infoBackground = Color.fromRGBO(27, 29, 43, 1);
//   static const infoColor = Color.fromRGBO(124, 179, 235, 1);

//   static const theory = Color.fromRGBO(242, 216, 105, 1);
//   static const practical = Color.fromRGBO(105, 224, 105, 1);
// }