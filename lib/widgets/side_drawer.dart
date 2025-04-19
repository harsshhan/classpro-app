import 'dart:ui';

import 'package:classpro/provider/user_provider.dart';
import 'package:classpro/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/service.dart';

class CustomDrawer extends StatefulWidget {
  final String currentRoute;

  const CustomDrawer({super.key,required this.currentRoute});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late Map<String, dynamic> userDataList;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userDataList = Provider.of<UserProvider>(context, listen: false).userData;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userDataList = Provider.of<UserProvider>(context).userData;
    return Drawer(
      backgroundColor: AppColors.bgColor,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              height: 80,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                        fontFamily: 'Geist',
                      ),
                    ),
                    const SizedBox(height: 8),
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
                _buildDrawerItem('Home', 'assets/icons/book_logo.png', context, '/home', isSelected: widget.currentRoute == '/home'),
                _buildDrawerItem('SGPA Calculator', 'assets/icons/gradex_icon.png', context, '/gradex', isSelected: widget.currentRoute == '/gradex'),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.pink.shade200,
                child: const Icon(Icons.person, color: Color.fromRGBO(247, 226, 226, 1)),
              ),
              title: Text(
                userDataList['name'],
                style: const TextStyle(color: Colors.white),
              ),
              tileColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              onTap: () {
                _showUserDetailsPopup(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Text(
                  'Community: ',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'Geist',
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 12,
                  child: InkWell(
                    onTap: () {},
                    child: Image.asset(
                      'assets/icons/whatsapp_icon.png',
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(String title, String iconPath, BuildContext context, String route, {bool isSelected = false}) {
    return ListTile(
      trailing: Image.asset(iconPath, width: 24, color: isSelected ? Colors.white : Colors.grey),
      title: Text(title, style: TextStyle(color: isSelected ? Colors.white : Colors.grey,fontWeight: FontWeight.bold,fontSize: 18)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      tileColor: isSelected ? Colors.white.withOpacity(0.1) : Colors.transparent,
      onTap: () {
        if (ModalRoute.of(context)?.settings.name != route) {
          Navigator.pushReplacementNamed(context, route);
        } else {
          Navigator.pop(context); // just close the drawer
        }
      },
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
                      Text(userDataList['name'],
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
                    userDataList['regNumber'],
                    style: TextStyle(
                        color: Color.fromRGBO(179, 179, 209, 1),
                        fontSize: 18,
                        fontFamily: 'Geist',
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
                          child: Text(userDataList['year'].toString(),
                              style: TextStyles.userDetailAns)),
                      Expanded(
                          child: Text(
                              userDataList['semester'].toString(),
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
                          child: Text(userDataList['section'],
                              style: TextStyles.userDetailAns)),
                      Expanded(
                          child: Text(userDataList['batch'],
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
                    userDataList['program'],
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
                  Text(userDataList['department'],
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
                      await apiService.logout();
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