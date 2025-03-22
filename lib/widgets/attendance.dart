import 'package:classpro/colors.dart';
import 'package:flutter/material.dart';

import '../api/service.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  late List<dynamic> attendanceData = [];
  late String regNumber = '';
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchAttendanceData();
  }

  Future<void> fetchAttendanceData() async {
    try {
      final Map<String, dynamic> parsedData = await (await ApiService.create()).getAttendance();
      setState(() {
        regNumber = parsedData['regNumber'] ?? '';
        attendanceData = parsedData['attendance'] ?? [];
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
      return Center(
        child: CircularProgressIndicator(
          color: Colors.orange,
        ),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Text(
          errorMessage,
          style: TextStyle(color: Colors.red),
        ),
      );
    }

    if (attendanceData.isEmpty) {
      return Center(
        child: Text(
          'No attendance data available',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: attendanceData.length,
      itemBuilder: (context, index) {
        final course = attendanceData[index];
        final category = course['category'];
        Color backgroundColor = index.isEven ? Color.fromRGBO(25, 28, 32, 1) : AppColors.bgColor;

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
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Text(
                            course['courseTitle'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'geist-sans',
                              fontWeight: FontWeight.w500,
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
          ),
        );
      },
    );
  }
}