import 'package:classpro/provider/user_provider.dart';
import 'package:classpro/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

int? globalTodayDayOrder = 1;

class Timetable extends StatefulWidget {
  const Timetable({super.key});

  @override
  State<Timetable> createState() => _TimetableState();
}

class _TimetableState extends State<Timetable> {
  List<dynamic> subjects = [];
  bool isLoading = true;
  String? errorMessage;
  int? selectedDay = globalTodayDayOrder;
  bool isTodaySelected = true;

  Map<String, dynamic>? timetableData;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    timetableData = userProvider.timetableData;
    globalTodayDayOrder = int.tryParse(
        Provider.of<UserProvider>(context, listen: false).todayDayOrder);
    selectedDay = globalTodayDayOrder;
    isTodaySelected = selectedDay == globalTodayDayOrder;
    isLoading = false;
  }

  List<dynamic> getSubjectsForDay(int? day) {
    if (day == null || timetableData == null) return [];
    final dayData = timetableData!['schedule']
        ?.firstWhere((d) => d['day'] == day, orElse: () => null);
    return dayData != null && dayData['table'] != null ? dayData['table'] : [];
  }

  final List<String> timeSlots = [
    "8:00-8:50",
    "8:50-9:40",
    "9:45-10:35",
    "10:40-11:30",
    "11:35-12:25",
    "12:30-1:20",
    "1:25-2:15",
    "2:20-3:10",
    "3:10-4:00",
    "4:00-4:50",
  ];

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            errorMessage!,
            style: const TextStyle(color: Colors.red, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    final daySubjects = getSubjectsForDay(selectedDay);

    return Column(
      children: [
        SingleChildScrollView(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: daySubjects.isEmpty ? 1 : timeSlots.length,
            itemBuilder: (context, index) {
              if (daySubjects.isEmpty) {
                return Container(
                  height: 120,
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: Color.fromRGBO(25, 28, 32, 1), width: 3),
                    color: AppColors.errorBackground,
                  ),
                  child: const Center(
                    child: Text(
                      "Holiday",
                      style: TextStyle(
                        color: AppColors.errorColor,
                        fontSize: 30,
                        fontFamily: 'Geist',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }

              final subject =
                  index < daySubjects.length ? daySubjects[index] : null;
              final bool isPractical =
                  subject != null && subject["courseType"] == "Practical";

              BorderRadius borderRadius = BorderRadius.zero;
              if (index == 0) {
                borderRadius = const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                );
              } else if (index == timeSlots.length - 1) {
                borderRadius = const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                );
              }

              return Column(
                children: [
                  Container(
                    height: 64,
                    margin: const EdgeInsets.symmetric(vertical: 0.4),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: subject != null
                          ? (isPractical
                              ? AppColors.practical
                              : AppColors.theory)
                          : const Color.fromRGBO(63, 90, 50, 1),
                      borderRadius: borderRadius,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 8, bottom: 3, left: 3, right: 3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            subject != null
                                ? (subject["name"] ?? "No Class")
                                : "No Class",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Geist',
                              fontSize: 12,
                              color: subject != null
                                  ? Colors.black
                                  : Colors.green[900],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                subject != null && subject["roomNo"] != null
                                    ? subject["roomNo"]
                                    : "",
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                    fontFamily: 'Geist',
                                    fontWeight: FontWeight.w600),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: Text(
                                  timeSlots[index],
                                  style: const TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 0.63),
                                      fontSize: 10,
                                      fontFamily: 'Geist',
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  final day = selectedDay ?? globalTodayDayOrder ?? 0;
                  selectedDay = day > 1 ? day - 1 : 5;
                  isTodaySelected = selectedDay == globalTodayDayOrder;
                });
              },
              icon: const Icon(Icons.arrow_back_ios),
              color: AppColors.accentColor,
              iconSize: 15,
            ),
            Text(
              getSubjectsForDay(selectedDay).isEmpty
                  ? 'Holiday'
                  : 'Day $selectedDay',
              style: const TextStyle(
                color: AppColors.accentColor,
                fontSize: 15,
                fontFamily: 'Geist',
                fontWeight: FontWeight.w600,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  final day = selectedDay ?? globalTodayDayOrder ?? 0;
                  selectedDay = day < 5 ? day +1  : 1;
                  isTodaySelected = selectedDay == globalTodayDayOrder;
                });
              },
              icon: const Icon(Icons.arrow_forward_ios),
              color: AppColors.accentColor,
              iconSize: 15,
            ),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedDay = globalTodayDayOrder;
                  globalTodayDayOrder = selectedDay;
                  isTodaySelected = true;
                });
              },
              child: Container(
                height: 30,
                width: 75,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: isTodaySelected
                        ? AppColors.successBackground
                        : Color.fromRGBO(27, 29, 31, 1)),
                child: Center(
                  child: Text(
                    "Today",
                    style: TextStyle(
                        color: isTodaySelected
                            ? AppColors.successColor
                            : Colors.white,
                        fontSize: 14,
                        fontFamily: 'Geist',
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
