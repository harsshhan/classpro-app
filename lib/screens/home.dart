import 'package:classpro/colors.dart';
import 'package:classpro/widgets/attendance.dart';
import 'package:classpro/widgets/marks.dart';
import 'package:classpro/widgets/timetable.dart';
import 'package:flutter/material.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgColor,
      child: SafeArea(
          child:Scaffold(
                    backgroundColor: AppColors.bgColor,
                    body: Padding(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Timetable",
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontFamily: 'geist-sans',
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.none)),
                      IconButton(onPressed: () {}, icon: Icon(Icons.download_sharp))
                    ],
                  ),
                  Timetable(),
                  SizedBox(height: 20,),
                  Text("Attendance",style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontFamily: 'geist-sans',
                              fontWeight: FontWeight.w600
                  )),
                  Attendance(),
                  SizedBox(height: 20,),
                  Text("Marks",style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontFamily: 'geist-sans',
                              fontWeight: FontWeight.w600
                  )),
                  Marks(),
                ],
              ),
            ),
                    ),
                  ),
      ),
    );
  }
}
