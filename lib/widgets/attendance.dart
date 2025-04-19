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
    final isTheory = category == 'Theory';
    Color backgroundColor =
        isEvenIndex ? const Color.fromRGBO(25, 28, 32, 1) : AppColors.bgColor;

    final int hoursPresent =
        int.parse(course['hoursConducted']) - int.parse(course['hoursAbsent']);
    final double percentage = double.parse(course['attendancePercentage']);

    Color percentageColor =
        percentage >= 75 ? Colors.white : Colors.red;

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
                      backgroundColor: isTheory
                          ? AppColors.warnBackground
                          : AppColors.successBackground,
                      radius: 12,
                      child: Text(
                        category == 'Theory' ? 'T' : 'P',
                        style: TextStyle(
                          color: isTheory
                              ? AppColors.warnColor
                              : AppColors.successColor,
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
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: calculateMargin(hoursPresent,
                                    int.parse(course['hoursConducted'])) >=
                                0
                            ? 'Margin: '
                            : 'Required: ',
                        style: calculateMargin(hoursPresent,
                                    int.parse(course['hoursConducted'])) >=
                                0
                            ? TextStyles
                                .margin // Define this with a color like green
                            : TextStyles
                                .required, // Define this with a color like red
                      ),
                      TextSpan(
                        text:
                            '${calculateMargin(hoursPresent, int.parse(course['hoursConducted'])).abs()}',
                        style: calculateMargin(hoursPresent,
                                    int.parse(course['hoursConducted'])) >=
                                0
                            ? TextStyles.marginValue // Maybe bold green
                            : TextStyles.requiredValue, // Maybe bold red
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.transparent,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: const BoxDecoration(
                              color: AppColors.successBackground,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                bottomLeft: Radius.circular(16),
                              ),
                            ),
                            child: Text(
                              hoursPresent.toString(),
                              style: const TextStyle(
                                color: AppColors.successColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: const BoxDecoration(
                              color: AppColors.errorBackground,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                              ),
                            ),
                            child: Text(
                              course['hoursAbsent'],
                              style: const TextStyle(
                                color: AppColors.errorColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
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
                        color: AppColors.totBackground,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        course['hoursConducted'],
                        style: const TextStyle(
                          color: AppColors.totColor,
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
