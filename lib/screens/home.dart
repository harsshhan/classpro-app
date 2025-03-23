import 'dart:ui';
import 'package:android_intent_plus/android_intent.dart' as android_intent;
import 'dart:io' show Platform;
import 'package:classpro/api/service.dart';
import 'package:classpro/widgets/attendance.dart';
import 'package:classpro/widgets/marks.dart';
import 'package:classpro/widgets/timetable.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';

class Home extends StatefulWidget {
  final Map<String, dynamic> userDataList;
  const Home({super.key, required this.userDataList});

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
          drawer: Drawer(
            backgroundColor: AppColors.bgColor,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    height: 120,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            'ClassPro',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'geist-sans',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Holiday',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    children: [
                      Divider(color: Colors.grey.shade600),
                      _buildDrawerItem('Home', 'assets/icons/book_logo.png',
                          context, '/home',
                          isSelected: true),
                      // _buildDrawerItem(
                      //     'Course list', Icons.school, context, '/courses'),
                      // _buildDrawerItem('Calendar', Icons.calendar_today,
                      //     context, '/calendar'),
                      // _buildDrawerItem('Links', Icons.link, context, '/links'),
                      // _buildDrawerItem(
                      //     'Faculties', Icons.group, context, '/faculties'),
                    ],
                  ),
                ),
                Spacer(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.pink.shade200,
                        child: const Icon(Icons.person,
                            color: Color.fromRGBO(247, 226, 226, 1)),
                      ),
                      title: const Text(
                        'Harshan A M',
                        style: TextStyle(color: Colors.white),
                      ),
                      tileColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onTap: () {
                        _showUserDetailsPopup(context);
                      }),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Text(
                        'Community: ',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: 'geist-sans',
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      SizedBox(
                        width: 12,
                        child: InkWell(
                            onTap: () {},
                            child: Image.asset(
                              'assets/icons/whatsapp_icon.png',
                              color: Colors.white,
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
                          fontFamily: 'geist-sans',
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
                  const Text(
                    "Attendance",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontFamily: 'geist-sans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Attendance(),
                  const Text(
                    "Marks",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontFamily: 'geist-sans',
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
                        InkWell(
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
                                print("Launched with intent");
                              } catch (e) {
                                print("Intent launch error: $e");
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
                                decoration: TextDecoration.overline),
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

  Widget _buildDrawerItem(
    String title,
    String img,
    BuildContext context,
    String route, {
    bool isSelected = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? Color.fromRGBO(31, 35, 42, 1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontSize: 18,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        trailing: SizedBox(
            width: 20,
            child: Image.asset(
              img,
              color: Colors.white,
            )),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: () {
          Navigator.pushNamed(context, route);
        },
      ),
    );
  }

  void _showUserDetailsPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Color.fromRGBO(31, 35, 42, 1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(widget.userDataList['name'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          )),
                      const Spacer(),
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.cancel_outlined,
                            color: Colors.red,
                          ))
                    ],
                  ),
                  Text(
                    widget.userDataList['regNumber'],
                    style: TextStyle(
                        color: Color.fromRGBO(179, 179, 209, 1),
                        fontSize: 18,
                        fontFamily: 'geist-sans',
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(
                        "Year:",
                        style: TextStyles.userDetailQn,
                      )),
                      Expanded(
                          child: Text("Semester:",
                              style: TextStyles.userDetailQn)),
                    ],
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(widget.userDataList['year'].toString(),
                              style: TextStyles.userDetailAns)),
                      Expanded(
                          child: Text(
                              widget.userDataList['semester'].toString(),
                              style: TextStyles.userDetailAns)),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(
                        "Section:",
                        style: TextStyles.userDetailQn,
                      )),
                      Expanded(
                          child:
                              Text("Batch:", style: TextStyles.userDetailQn)),
                    ],
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(widget.userDataList['section'],
                              style: TextStyles.userDetailAns)),
                      Expanded(
                          child: Text(widget.userDataList['batch'],
                              style: TextStyles.userDetailAns)),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Program: ",
                    style: TextStyles.userDetailQn,
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    widget.userDataList['program'],
                    style: TextStyles.userDetailAns,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Department: ",
                    style: TextStyles.userDetailQn,
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(widget.userDataList['department'],
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500)),
                  SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: () async {
                      ApiService apiService = await ApiService.create();
                      await apiService.logout(context);
                    },
                    child: Container(
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          "Logout",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
