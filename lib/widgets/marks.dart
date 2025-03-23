import 'package:flutter/material.dart';
import '../api/service.dart';

import '../constants.dart';

class Marks extends StatefulWidget {
  const Marks({super.key});

  @override
  State<Marks> createState() => _MarksState();
}

class _MarksState extends State<Marks> {
  late List<dynamic> marksData = [];
  late String regNumber = '';
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchMarksData(); 
  }

  Future<void> fetchMarksData() async {
    try {
      final Map<String, dynamic> parsedData = await (await ApiService.create()).getMarks();
      setState(() {
        regNumber = parsedData['regNumber'] ?? '';
        marksData = parsedData['marks'] ?? [];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error fetching data: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Text(
          errorMessage,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    final List<dynamic> theoryCourses =
        marksData.where((course) => course['courseType'] == 'Theory').toList();
    final List<dynamic> practicalCourses =
        marksData.where((course) => course['courseType'] == 'Practical').toList();

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        ...theoryCourses.map((course) {
          return buildCourseCard(course);
        }),
        if (practicalCourses.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "Practical",
              style: TextStyle(
                color: Colors.green,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...practicalCourses.map((course) {
            return buildCourseCard(course);
          }),
        ],
      ],
    );
  }

  Widget buildCourseCard(dynamic course) {
    final String subjectName = course['courseName'];
    final String courseType = course['courseType'];
    final overall = course['overall'];
    final testPerformance = course['testPerformance'];

    double cardHeight = 150.0;
    if (testPerformance != null) {
      cardHeight += testPerformance.length * 45.0;
    }

    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromRGBO(25, 28, 32, 1),
      ),
      height: cardHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  subjectName,
                  style: TextStyles.courseName,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              CircleAvatar(
                backgroundColor:
                    courseType == 'Theory' ? Colors.yellow : Colors.green,
                radius: 15,
                child: Text(
                  courseType == 'Theory' ? 'T' : 'P',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (testPerformance != null)
            ...testPerformance.map((test) {
              final testName = test['test'];
              final testMarks = test['marks'];
              final scored = testMarks['scored'];
              final total = testMarks['total'];

              bool isValidScore = scored != "Abs";
              double? scoreValue =
                  isValidScore ? double.tryParse(scored) : null;
              double? totalValue = double.tryParse(total);

              bool isPerfectScore = isValidScore &&
                  totalValue != null &&
                  scoreValue != null &&
                  scoreValue >= totalValue;

              Color markColor = isPerfectScore
                  ? Colors.green
                  : scored == 'Abs'
                      ? Colors.red
                      : Colors.white;

              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      testName,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: isPerfectScore
                                  ? Colors.green
                                  : Colors.black,
                            ),
                          ),
                          child: Text(
                            scored,
                            style: TextStyle(
                              color: markColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.tot_marks_bgColor,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            total,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          Divider(
            color: Colors.grey.shade600,
            thickness: 1,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      overall['scored'],
                      style: TextStyle(
                        color: overall['scored'] == overall['total']
                            ? Colors.green
                            : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.tot_marks_bgColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      overall['total'],
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}