import 'dart:convert';

import 'package:classpro/colors.dart';
import 'package:flutter/material.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {

  late List<dynamic> attendanceData;
  late String regNumber;

  @override
  void initState() {
    super.initState();
    // Parse your JSON data
    final jsonData = '''{
      "regNumber": "RA2311026010086",
      "attendance": [
        {
          "courseCode": "21MAB204T",
          "courseTitle": "Probability and Queueing Theory",
          "category": "Theory",
          "facultyName": "Dr. Sahadeb Kuila (102759)",
          "slot": "A",
          "hoursConducted": "38",
          "hoursAbsent": "4",
          "attendancePercentage": "89.47"
        },
        {
          "courseCode": "21CSC204J",
          "courseTitle": "Design and Analysis of Algorithms",
          "category": "Theory",
          "facultyName": "Rajalakshmi S (103429)",
          "slot": "B",
          "hoursConducted": "26",
          "hoursAbsent": "5",
          "attendancePercentage": "80.77"
        },
        {
          "courseCode": "21CSE251T",
          "courseTitle": "Digital Image Processing",
          "category": "Theory",
          "facultyName": "Dr. Gowtham P (103464)",
          "slot": "C",
          "hoursConducted": "24",
          "hoursAbsent": "3",
          "attendancePercentage": "87.50"
        },
        {
          "courseCode": "21CSC205P",
          "courseTitle": "Database Management Systems",
          "category": "Theory",
          "facultyName": "Dr Kiruthika M (103056)",
          "slot": "D",
          "hoursConducted": "31",
          "hoursAbsent": "10",
          "attendancePercentage": "67.74"
        },
        {
          "courseCode": "21PDH209T",
          "courseTitle": "Social Engineering",
          "category": "Theory",
          "facultyName": "Dr Kiruthika M (103056)",
          "slot": "E",
          "hoursConducted": "15",
          "hoursAbsent": "4",
          "attendancePercentage": "73.33"
        },
        {
          "courseCode": "21CSC206T",
          "courseTitle": "Artificial Intelligence",
          "category": "Theory",
          "facultyName": "Dr.M.S.Abirami (100489)",
          "slot": "F",
          "hoursConducted": "28",
          "hoursAbsent": "6",
          "attendancePercentage": "78.57"
        },
        {
          "courseCode": "21LEM202T",
          "courseTitle": "UHV-II: Universal Human Values",
          "category": "Theory",
          "facultyName": "Dr. S. Vimal (102820)",
          "slot": "G",
          "hoursConducted": "28",
          "hoursAbsent": "3",
          "attendancePercentage": "89.29"
        },
        {
          "courseCode": "21CSC204J",
          "courseTitle": "Design and Analysis of Algorithms",
          "category": "Practical",
          "facultyName": "Rajalakshmi S (103429)",
          "slot": "LAB",
          "hoursConducted": "18",
          "hoursAbsent": "4",
          "attendancePercentage": "77.78"
        }
      ],
      "status": 200
    }''';
    
    final Map<String, dynamic> parsedData = jsonDecode(jsonData);
    regNumber = parsedData['regNumber'];
    attendanceData = parsedData['attendance'];
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: attendanceData.length,
        itemBuilder: (context, index) {
          final course = attendanceData[index];
          final category = course['category'];
          Color backgroundColor = index.isEven ? Color.fromRGBO(25,28,32,1) : AppColors.bgColor ;
          
          final int hoursPresent = int.parse(course['hoursConducted']) - int.parse(course['hoursAbsent']);
          
          final double percentage = double.parse(course['attendancePercentage']);
          
          Color percentageColor = percentage >= 75 ? Color(0xFF4CAF50) : Colors.red;
          
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: category == 'Theory' ? Colors.yellow : Colors.green,
                            radius: 12,
                            child: Text(
                              category == 'Theory' ? 'T' : 'P',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Text(
                              course['courseTitle'],
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                      
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Color(0xFF1E1E1E),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  hoursPresent.toString(),
                                  style: TextStyle(
                                    color: Color(0xFF4CAF50),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  course['hoursAbsent'],
                                  style: TextStyle(
                                    color: Color(0xFFF44336),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Color(0xFF303030),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              course['hoursConducted'],
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "${percentage.toStringAsFixed(2)}%",
                        style: TextStyle(
                          color: percentageColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ));

  });
  }

  Color _getCourseColor(String courseCode) {
    if (courseCode.contains('MAB')) return Colors.amber;
    if (courseCode.contains('CSC')) return Colors.blue;
    if (courseCode.contains('CSE')) return Colors.green;
    if (courseCode.contains('PDH')) return Colors.purple;
    if (courseCode.contains('LEM')) return Colors.orange;
    return Colors.teal;
  }

  String _calculateMargin(dynamic course) {
    final int totalClasses = int.parse(course['hoursConducted']);
    final int absences = int.parse(course['hoursAbsent']);
    
    // Calculate how many more classes can be missed while keeping attendance above 75%
    final int minRequired = (totalClasses * 0.75).ceil();
    final int attended = totalClasses - absences;
    final int margin = attended - minRequired;
    
    return margin.toString();
  }
  
  // Get margin color based on value
  Color _getMarginColor(dynamic course) {
    final int margin = int.parse(_calculateMargin(course));
    if (margin < 0) return Colors.red;
    if (margin <= 2) return Colors.orange;
    return Colors.blue;
  }

  }


  