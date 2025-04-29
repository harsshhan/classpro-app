import 'package:android_intent_plus/android_intent.dart' as android_intent;
import 'package:classpro/provider/user_provider.dart';
import 'package:classpro/screens/connectionScreen.dart';
import 'dart:io' show Platform;
import 'package:classpro/widgets/attendance.dart';
import 'package:classpro/widgets/marks.dart';
import 'package:classpro/widgets/side_drawer.dart';
import 'package:classpro/widgets/timetable.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api/service.dart';
import '../styles.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<void> refreshAppData(BuildContext context) async {
  try {
    final bool result = await InternetConnectionChecker.instance.hasConnection;
    if (!mounted) return;

    if (result) {
      final api = await ApiService.create();

      final userData = await api.validateToken();
      final marks = await api.getMarks();
      final attendance = await api.getAttendance();
      final timetable = await api.getTimetable();
      final calendar = await api.getCalendar();

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setUserData(userData);
      userProvider.setMarksData(marks);
      userProvider.setAttendanceData(attendance);
      userProvider.setTimetableData(timetable);
      userProvider.setCalendarData(calendar);
    } else {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => NoInternetScreen(
          onRetry: () async {
            Navigator.of(context).pop(); 
            await refreshAppData(context); 
          },
        ),
      ));
    }
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to refresh: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

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
          body: RefreshIndicator(
              onRefresh: () => refreshAppData(context),
              child: Padding(
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
              )),
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
