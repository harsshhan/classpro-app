import 'package:classpro/provider/user_provider.dart';
import 'package:classpro/styles.dart';
import 'package:classpro/widgets/gradex_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/side_drawer.dart';

class GradexPage extends StatefulWidget {
  const GradexPage({
    super.key,
  });

  @override
  State<GradexPage> createState() => _GradexPageState();
}

class _GradexPageState extends State<GradexPage> {
  Map<String, Map<String, dynamic>> selectedGrades = {};
  double sgpa = 0.0;

  double calculateSGPA() {
    Map<String, int> gradePoints = {
      'O': 10,
      'A+': 9,
      'A': 8,
      'B+': 7,
      'B': 6,
      'RA': 0,
    };

    int totalCredits = 0;
    int totalWeightedPoints = 0;

    selectedGrades.forEach((subject, data) {
      final included = data['included'] ?? true; 
      if (included == false ) return;

      final grade = data['grade'];
      final credits = data['credits'] is int
          ? data['credits'] as int
          : int.tryParse(data['credits'].toString()) ?? 0;
      final points = gradePoints[grade] ?? 0;

      totalCredits += credits;
      totalWeightedPoints += points * credits;
    });

    if (totalCredits == 0) return 0.0;
    return totalWeightedPoints / totalCredits;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final storedMarksData = userProvider.marksData['marks'];
      final courseList = userProvider.courseList;

      for (int i = 0; i < storedMarksData.length; i++) {
        if (storedMarksData[i]['courseType'] == 'Theory') {
          final subject = storedMarksData[i]['courseName'];
          final credit = courseList[i]['credit'];
          selectedGrades[subject] = {
            'grade': 'A',
            'credits': credit,
            'included': true
          };
        }
      }

      setState(() {
        sgpa = calculateSGPA();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final storedMarksData = userProvider.marksData['marks'];
    final courseList = userProvider.courseList;

    return Container(
      color: AppColors.backgroundDark,
      child: SafeArea(
        child: Scaffold(
          drawerEdgeDragWidth: MediaQuery.of(context).size.width * 0.5,
          backgroundColor: AppColors.backgroundDark,
          drawer: CustomDrawer(currentRoute: '/gradex'),
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
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: ListView(
                  children: [
                    ...List.generate(storedMarksData.length, (index) {
                      if (storedMarksData[index]['courseType'] == 'Theory') {
                        final subject = storedMarksData[index]['courseName'];
                        final credit = courseList[index]['credit'];
                        final gradexWidget = GradexWidget(
                            courseName: subject,
                            credit: credit,
                            scored: storedMarksData[index]['overall']['scored'],
                            total: storedMarksData[index]['overall']['total'],
                            grade: selectedGrades[subject]?['grade'] ?? 'A',
                            included:
                                selectedGrades[subject]?['included'] ?? true,
                            onIncludeChanged: (val) {
                              setState(() {
                                selectedGrades[subject]?['included'] = val;
                                sgpa = calculateSGPA();
                              });
                            },
                            onGradeSelected: (grade, credits) {
                              setState(() {
                                selectedGrades[subject] = {
                                  'grade': grade,
                                  'credits': credits,
                                  'included': selectedGrades[subject]
                                          ?['included'] ??
                                      true
                                };
                                sgpa = calculateSGPA();
                              });
                            });

                        if (index == 0) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "GradeX",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 20),
                              gradexWidget,
                            ],
                          );
                        } else {
                          return gradexWidget;
                        }
                      } else {
                        return const SizedBox();
                      }
                    }),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                      height: 60,
                      width: 160,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.successBackground,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              sgpa.toStringAsFixed(2),
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w600,
                                color: AppColors.successColor,
                              ),
                            ),
                            SizedBox(width: 4),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  "SGPA",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        AppColors.successColor.withOpacity(0.6),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
