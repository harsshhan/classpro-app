import 'package:flutter/material.dart';

import '../api/service.dart';
import '../styles.dart';

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

  int calculateMargin(int present, int total) {
    const int pMin = 75;

    if ((present / total) * 100 >= pMin) {
      return ((present - 0.75 * total) / 0.75).floor();
    }

    int requiredClassesToAttend = 0;
    while (((present + requiredClassesToAttend) /
                (total + requiredClassesToAttend)) *
            100 <
        pMin) {
      requiredClassesToAttend++;
    }

    return -requiredClassesToAttend;
  }

  Future<void> fetchAttendanceData() async {
    try {
      final Map<String, dynamic> parsedData =
          await (await ApiService.create()).getAttendance();
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

  Widget _buildAttendanceCard(dynamic course, bool isEvenIndex) {
    final category = course['category'];
    Color backgroundColor =
        isEvenIndex ? const Color.fromRGBO(25, 28, 32, 1) : AppColors.bgColor;

    final int hoursPresent =
        int.parse(course['hoursConducted']) - int.parse(course['hoursAbsent']);
    final double percentage = double.parse(course['attendancePercentage']);

    Color percentageColor =
        percentage >= 75 ? const Color(0xFF4CAF50) : Colors.red;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
      child: Container(
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor:
                          category == 'Theory' ? Colors.yellow : Colors.green,
                      radius: 12,
                      child: Text(
                        category == 'Theory' ? 'T' : 'P',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        course['courseTitle'],
                        style: TextStyles.courseName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
                Text(
                  "${calculateMargin(hoursPresent, int.parse(course['hoursConducted'])) >= 0 ? 'Margin: ' : 'Required: '}"
                  "${calculateMargin(hoursPresent, int.parse(course['hoursConducted'])).abs()}",
                  style: calculateMargin(hoursPresent,
                              int.parse(course['hoursConducted'])) >=
                          0
                      ? TextStyles.margin
                      : TextStyles.required,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Text(
                            hoursPresent.toString(),
                            style: const TextStyle(
                              color: Color(0xFF4CAF50),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            course['hoursAbsent'],
                            style: const TextStyle(
                              color: Color(0xFFF44336),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      margin: EdgeInsets.zero,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF303030),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        course['hoursConducted'],
                        style: const TextStyle(
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
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.orange,
        ),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Text(
          errorMessage,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (attendanceData.isEmpty) {
      return const Center(
        child: Text(
          'No attendance data available',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    final List<dynamic> theoryCourses = attendanceData
        .where((course) => course['category'] == 'Theory')
        .toList()
      ..sort((a, b) {
        final aPresent =
            int.parse(a['hoursConducted']) - int.parse(a['hoursAbsent']);
        final bPresent =
            int.parse(b['hoursConducted']) - int.parse(b['hoursAbsent']);
        final aRequired =
            calculateMargin(aPresent, int.parse(a['hoursConducted'])) < 0;
        final bRequired =
            calculateMargin(bPresent, int.parse(b['hoursConducted'])) < 0;
        if (aRequired != bRequired) {
          return aRequired ? -1 : 1;
        }
        return 0;
      });

    final List<dynamic> practicalCourses = attendanceData
        .where((course) => course['category'] == 'Practical')
        .toList()
      ..sort((a, b) {
        final aPresent =
            int.parse(a['hoursConducted']) - int.parse(a['hoursAbsent']);
        final bPresent =
            int.parse(b['hoursConducted']) - int.parse(b['hoursAbsent']);
        final aRequired =
            calculateMargin(aPresent, int.parse(a['hoursConducted'])) < 0;
        final bRequired =
            calculateMargin(bPresent, int.parse(b['hoursConducted'])) < 0;
        if (aRequired != bRequired) {
          return aRequired ? -1 : 1;
        }
        return 0;
      });

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Attendance',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () {
                  // TODO: Implement prediction logic
                },
                icon: const Icon(
                  Icons.analytics_outlined,
                  color: Colors.white,
                ),
                tooltip: 'Predict Attendance',
              ),
            ],
          ),
        ),
        ...theoryCourses.asMap().entries.map((entry) {
          return _buildAttendanceCard(entry.value, entry.key.isEven);
        }),
        if (practicalCourses.isNotEmpty) ...[
          Row(
            children: [
              const Text(
                "Practical",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 1,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          ...practicalCourses.asMap().entries.map((entry) {
            return _buildAttendanceCard(entry.value, entry.key.isEven);
          }),
        ],
      ],
    );
  }
}
