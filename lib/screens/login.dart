import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(10, 12, 16, 1),
        // gradient: AppColors.darkGradient,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            height: 410,
            width: 408,
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(50)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "ClassPro",
                        style: TextStyle(
                            fontSize: 24,
                            color: Color.fromRGBO(179, 179, 209, 1),
                            decoration: TextDecoration.none),
                      ),
SvgPicture.asset("assets/icons/logo1.svg", semanticsLabel: 'Dart Logo')                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
