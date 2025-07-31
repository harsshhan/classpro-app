import 'package:classpro/provider/user_provider.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../styles.dart';
import 'score_box.dart';

class Marks extends StatefulWidget {
  const Marks({super.key});

  @override
  State<Marks> createState() => _MarksState();
}

class _MarksState extends State<Marks> {
  bool isLoading = true;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final storedMarksData = userProvider.marksData;

    final isLoading = userProvider.isLoading;

    final List<dynamic> marks = storedMarksData['marks'] ?? [];

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
        marks.where((course) => course['courseType'] == 'Theory').toList();
    final List<dynamic> practicalCourses =
        marks.where((course) => course['courseType'] == 'Practical').toList();

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        ...theoryCourses.map((course) {
          return buildCourseCard(course);
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
    final isTheory = courseType == 'Theory';
    final overall = course['overall'];
    final testPerformance = course['testPerformance'];

    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.backgroundNormal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Text(
                  subjectName,
                  style: TextStyles.courseName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              CircleAvatar(
                backgroundColor: isTheory
                    ? AppColors.warnBackground
                    : AppColors.successBackground,
                radius: 12,
                child: Text(
                  courseType == 'Theory' ? 'T' : 'P',
                  style: TextStyle(
                    color:
                        isTheory ? AppColors.warnColor : AppColors.successColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (testPerformance == null)
            Container(
              padding: EdgeInsets.all(12),
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                  color: AppColors.darkSiide,
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Text("No Tests Conducted",style:TextStyle(color: AppColors.darkAccent,fontSize: 12,),)
              ),
            )
          else
            ...testPerformance.map<Widget>((test) {
              final testName = test['test'];
              final testMarks = test['marks'];
              final scored = testMarks['scored'];
              final total = testMarks['total'];

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
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
                    ScoreBoxPair(
                      scored: scored,
                      total: total,
                    ),
                  ],
                ),
              );
            }).toList(),

          DottedLine(
            dashLength: 4,
            dashGapLength: 10,
            lineThickness: 1,
            dashColor: AppColors.backgroundLight,
          ),
          // Divider(
          //   color: Colors.grey.shade600,
          //   thickness: 1,
          // ),
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
              ScoreBoxPair(
                scored: overall['scored'],
                total: overall['total'],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
