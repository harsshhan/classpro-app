import 'package:android_intent_plus/android_intent.dart' as android_intent;
import 'package:classpro/provider/user_provider.dart';
import 'dart:io' show Platform;
import 'package:classpro/widgets/attendance.dart';
import 'package:classpro/widgets/marks.dart';
import 'package:classpro/widgets/side_drawer.dart';
import 'package:classpro/widgets/timetable.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../styles.dart';

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
        child: Scaffold(
          drawerEdgeDragWidth: MediaQuery.of(context).size.width * 0.5,
          backgroundColor: AppColors.bgColor,
          drawer: CustomDrawer(
            currentRoute: '/home',
          ),
          body: Padding(
            padding: const EdgeInsets.all(18),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Timetable",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontFamily: 'Geist',
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.download_sharp,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  const Timetable(),
                  const SizedBox(height: 20),
                  const Attendance(),
                  const SizedBox(height: 20),
                  const Text(
                    "Marks",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontFamily: 'Geist',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Marks(),
                  const SizedBox(height: 20),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Developed by ",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            const url =
                                'https://www.linkedin.com/in/harshan-am';

                            if (Platform.isAndroid) {
                              try {
                                final intent = android_intent.AndroidIntent(
                                  action: 'action_view',
                                  data: url,
                                );
                                await intent.launch();
                              } catch (e) {
                                null;
                              }
                            } else {
                              // For iOS devices
                              if (await canLaunchUrl(Uri.parse(url))) {
                                await launchUrl(Uri.parse(url),
                                    mode: LaunchMode.externalApplication);
                              }
                            }
                          },
                          child: Text(
                            "Harshan",
                            style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                                decoration: TextDecoration.underline),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          floatingActionButton: Builder(
            builder: (context) => FloatingActionButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                backgroundColor: Colors.transparent,
                elevation: 0,
                splashColor: Colors.transparent,
                highlightElevation: 0,
                hoverElevation: 0,
                child: SizedBox(
                    height: 25,
                    child: Image.asset(
                      "assets/icons/arrow_icon.png",
                      color: Colors.white,
                    ))),
          ),
        ),
      ),
    );
  }
}
