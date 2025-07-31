import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/user_provider.dart';
import '../styles.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  late String regNumber = '';
  bool isLoading = true;
  String errorMessage = '';

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

  Widget _buildAttendanceCard(dynamic course, bool isEvenIndex) {
    final category = course['category'];
    final isTheory = category == 'Theory';
    Color backgroundColor =
        isEvenIndex ? const Color.fromRGBO(25, 28, 32, 1) : AppColors.bgColor;

    final int hoursPresent =
        int.parse(course['hoursConducted']) - int.parse(course['hoursAbsent']);
    final double percentage = double.parse(course['attendancePercentage']);

    Color percentageColor = percentage >= 75 ? Colors.white : AppColors.errorColor;

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
            // Course title row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: isTheory
                          ? AppColors.warnBackground
                          : AppColors.successBackground,
                      radius: 12,
                      child: Text(
                        isTheory ? 'T' : 'P',
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
                            ? TextStyles.margin
                            : TextStyles.required,
                      ),
                      TextSpan(
                        text:
                            '${calculateMargin(hoursPresent, int.parse(course['hoursConducted'])).abs()}',
                        style: calculateMargin(hoursPresent,
                                    int.parse(course['hoursConducted'])) >=
                                0
                            ? TextStyles.marginValue
                            : TextStyles.requiredValue,
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),

            // Present, Absent, Total and % row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // Present / Absent
                    Container(
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
                    // Total
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 5),
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
    final userProvider = Provider.of<UserProvider>(context);
    final isLoading = userProvider.isLoading;
    final attendanceData = userProvider.attendanceData;


    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.orange),
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

    final List<dynamic> attendanceList = attendanceData['attendance'] ?? [];
    final List<dynamic> theoryCourses = attendanceList
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
        return aRequired != bRequired ? (aRequired ? -1 : 1) : 0;
      });

    final List<dynamic> practicalCourses = attendanceList
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
        return aRequired != bRequired ? (aRequired ? -1 : 1) : 0;
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
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: 'Geist',
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.none,
                            ),
              ),
              InkWell(
                onTap: () {
                  
                },
                child: Image.asset('assets/icons/prediction.png',
                height: 20,
                width: 20,
                    color: AppColors.accentColor),
              )
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
