import 'dart:convert';
import 'package:flutter/material.dart';

// class TimetableScreen extends StatelessWidget {
//   final String jsonData = '''
//   {
//     "schedule": [
//       {
//         "day": 2,
//         "table": [
//           null, null, null, null, null,
//           {
//             "code": "21CSC204J",
//             "name": "Design and Analysis of Algorithms",
//             "slot": "B",
//             "roomNo": "LH506",
//             "courseType": "Theory",
//             "online": false,
//             "isOptional": false
//           },
//           {
//             "code": "21CSC204J",
//             "name": "Design and Analysis of Algorithms",
//             "slot": "B",
//             "roomNo": "LH506",
//             "courseType": "Theory",
//             "online": false,
//             "isOptional": false
//           },
//           {
//             "code": "21LEM202T",
//             "name": "UHV-II",
//             "slot": "G",
//             "roomNo": "LH506",
//             "courseType": "Theory",
//             "online": false,
//             "isOptional": false
//           },
//           {
//             "code": "21LEM202T",
//             "name": "UHV-II",
//             "slot": "G",
//             "roomNo": "LH506",
//             "courseType": "Theory",
//             "online": false,
//             "isOptional": false
//           },
//           {
//             "code": "21MAB204T",
//             "name": "Probability and Queueing Theory",
//             "slot": "A",
//             "roomNo": "LH506",
//             "courseType": "Theory",
//             "online": false,
//             "isOptional": false
//           }
//         ]
//       }
//     ]
//   }
//   ''';

//   final List<String> timeSlots = [
//     "8:00-8:50",
//     "8:50-9:40",
//     "9:45-10:35",
//     "10:40-11:30",
//     "11:35-12:25",
//     "12:30-1:20",
//     "1:25-2:15",
//     "2:20-3:10",
//     "3:10-4:00",
//     "4:00-4:50",
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final Map<String, dynamic> data = jsonDecode(jsonData);
//     final List<dynamic> schedule = data["schedule"];
//     final List<dynamic> subjects = schedule[0]["table"];

//     return
//       Padding(
//         padding: const EdgeInsets.all(0),
//         child: Container(

//             margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black26,
//                   blurRadius: 8,
//                   spreadRadius: 2,
//                   offset: Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: ListView.separated(
//               itemCount: timeSlots.length,
//               separatorBuilder: (context, index) => Divider(
//                 color: Colors.black,
//                 thickness: 1,
//               ),
//               itemBuilder: (context, index) {
//                 final subject = subjects[index];

//                 return Container(
//                   padding: EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(15),
//                     color: subject != null ? Colors.amber[300] : Colors.green[900],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       if (subject != null) ...[
//                         Text(
//                           subject["name"],
//                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                         Text(
//                           subject["roomNo"],
//                           style: TextStyle(fontSize: 14, color: Colors.black87),
//                         ),
//                       ],
//                       Align(
//                         alignment: Alignment.centerRight,
//                         child: Text(
//                           timeSlots[index],
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),

//             ),
//       );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';

class Timetable extends StatefulWidget {
  const Timetable({super.key});

  @override
  State<Timetable> createState() => _TimetableState();
}

class _TimetableState extends State<Timetable> {
  final String jsonData = '''
  {
    "schedule": [
      {
        "day": 2,
        "table": [
          null, null, null, null, null,
          {
            "code": "21CSC204J",
            "name": "Design and Analysis of Algorithms",
            "slot": "B",
            "roomNo": "LH506",
            "courseType": "Theory",
            "online": false,
            "isOptional": false
          },
          {
            "code": "21CSC204J",
            "name": "Design and Analysis of Algorithms",
            "slot": "B",
            "roomNo": "LH506",
            "courseType": "Theory",
            "online": false,
            "isOptional": false
          },
          {
            "code": "21LEM202T",
            "name": "UHV-II",
            "slot": "G",
            "roomNo": "LH506",
            "courseType": "Theory",
            "online": false,
            "isOptional": false
          },
          {
            "code": "21LEM202T",
            "name": "UHV-II",
            "slot": "G",
            "roomNo": "LH506",
            "courseType": "Theory",
            "online": false,
            "isOptional": false
          },
          {
            "code": "21MAB204T",
            "name": "Probability and Queueing Theory",
            "slot": "A",
            "roomNo": "LH506",
            "courseType": "Theory",
            "online": false,
            "isOptional": false
          }
        ]
      }
    ]
  }
  ''';

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
    final Map<String, dynamic> data = jsonDecode(jsonData);
    final List<dynamic> schedule = data["schedule"];
    final List<dynamic> subjects = schedule[0]["table"];

    return SingleChildScrollView(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: timeSlots.length,
        itemBuilder: (context, index) {
          final subject = subjects[index];

          // Determine border radius
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
                margin: const EdgeInsets.symmetric(vertical: 0.4, horizontal: 12),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: subject != null ? Color.fromRGBO(235, 215, 112, 1) : Color.fromRGBO(63, 90, 50, 3),
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
                          subject == null ? "" : subject["name"],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: subject != null ? Colors.black87 : Colors.green[900],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subject != null ? subject["roomNo"] : "",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
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