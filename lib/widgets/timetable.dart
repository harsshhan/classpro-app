import 'package:classpro/api/service.dart';
import 'package:flutter/material.dart';

class Timetable extends StatefulWidget {
  const Timetable({super.key});

  @override
  State<Timetable> createState() => _TimetableState();
}

class _TimetableState extends State<Timetable> {
  List<dynamic> subjects = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchTimetable();
  }

  Future<void> _fetchTimetable() async {
    try {
      final Map<String, dynamic> data = await (await ApiService.create()).getTimetable();

      if (data.containsKey("schedule") && data["schedule"] != null) {
        final List<dynamic> schedule = data["schedule"];

        if (schedule.isNotEmpty && schedule[0]["table"] != null) {
          setState(() {
            subjects = schedule[0]["table"];
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = "No timetable data available.";
            isLoading = false;
          });
        }
      } else {
        throw Exception("Invalid or null data received.");
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error fetching timetable: $e";
        isLoading = false;
      });
    }
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

    return SingleChildScrollView(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: timeSlots.length,
        itemBuilder: (context, index) {
          final subject = index < subjects.length ? subjects[index] : null;

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
                  color: subject != null ? const Color.fromRGBO(235, 215, 112, 1) : const Color.fromRGBO(63, 90, 50, 1),
                  borderRadius: borderRadius,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subject != null ? (subject["name"] ?? "No Class") : "No Class",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: 'geist-sans',
                            fontSize: 10,

                            color: subject != null ? Colors.black87 : Colors.green[900],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subject != null && subject["roomNo"] != null
                              ? subject["roomNo"]
                              : "",
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.black54,
                            fontFamily: 'geist-sans',
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Text(
                            timeSlots[index],
                            style: const TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 0.63),
                              fontSize: 10,
                              fontFamily: 'geist-sans',
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}