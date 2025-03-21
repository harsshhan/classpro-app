import 'dart:convert';
import 'package:classpro/colors.dart';
import 'package:flutter/material.dart';

class Marks extends StatefulWidget {
  const Marks({super.key});

  @override
  State<Marks> createState() => _MarksState();
}

class _MarksState extends State<Marks> {
  String jsonData = '''
{
  "regNumber": "RA2311026010086",
  "marks": [
    {
      "courseName": "Design and Analysis of Algorithms",
      "courseCode": "21CSC204J",
      "courseType": "Practical",
      "overall": {
        "scored": "0.00",
        "total": "0.00"
      },
      "testPerformance": null
    },
    {
      "courseName": "Probability and Queueing Theory",
      "courseCode": "21MAB204T",
      "courseType": "Theory",
      "overall": {
        "scored": "16.50",
        "total": "20.00"
      },
      "testPerformance": [
        {
          "test": "FT-I",
          "marks": {
            "scored": "5.00",
            "total": "5.00"
          }
        },
        {
          "test": "FT-II",
          "marks": {
            "scored": "11.50",
            "total": "15.00"
          }
        }
      ]
    },
    {
      "courseName": "Design and Analysis of Algorithms",
      "courseCode": "21CSC204J",
      "courseType": "Theory",
      "overall": {
        "scored": "11.00",
        "total": "15.00"
      },
      "testPerformance": [
        {
          "test": "FJ-I",
          "marks": {
            "scored": "11.00",
            "total": "15.00"
          }
        }
      ]
    },
    {
      "courseName": "Artificial Intelligence",
      "courseCode": "21CSC206T",
      "courseType": "Theory",
      "overall": {
        "scored": "14.70",
        "total": "20.00"
      },
      "testPerformance": [
        {
          "test": "FT-I",
          "marks": {
            "scored": "4.10",
            "total": "5.00"
          }
        },
        {
          "test": "FT-II",
          "marks": {
            "scored": "10.60",
            "total": "15.00"
          }
        }
      ]
    },
    {
      "courseName": "Design and Analysis of Algorithms",
      "courseCode": "21CSC204J",
      "courseType": "Practical",
      "overall": {
        "scored": "0.00",
        "total": "0.00"
      },
      "testPerformance": null
    }
  ],
  "status": 200
}
''';

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data = jsonDecode(jsonData);
    final List<dynamic> marks = data["marks"];

    // Separate theory and practical courses
    final List<dynamic> theoryCourses =
        marks.where((course) => course['courseType'] == 'Theory').toList();
    final List<dynamic> practicalCourses =
        marks.where((course) => course['courseType'] == 'Practical').toList();

    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        ...theoryCourses.map((course) {
          return buildCourseCard(course);
        }).toList(),

        if (practicalCourses.isNotEmpty) ...[

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "Practical",
              style: TextStyle(
                color: Colors.orange,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...practicalCourses.map((course) {
            return buildCourseCard(course);
          }).toList(),
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
      cardHeight += testPerformance.length * 40.0;
    }

    return Container(
      margin: EdgeInsets.only(top: 5, bottom: 5),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color.fromRGBO(25, 28, 32, 1),
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
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              CircleAvatar(
                backgroundColor:
                    courseType == 'Theory' ? Colors.yellow : Colors.green,
                radius: 15,
                child: Text(
                  courseType == 'Theory' ? 'T' : 'P',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
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
                padding: EdgeInsets.only(bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      testName,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
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
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: AppColors.tot_marks_bgColor,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Text(
                                  total,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
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
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
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
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.black,
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.tot_marks_bgColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      overall['total'],
                      style: TextStyle(
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
