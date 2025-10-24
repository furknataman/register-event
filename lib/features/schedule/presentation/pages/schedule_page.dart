import 'package:flutter/material.dart';
import '../../domain/models/time_entry.dart';
import '../../../../core/theme/app_colors.dart';

class SchedulePage extends StatelessWidget {
  SchedulePage({super.key});

  final List<TimeEntry> entries = [
    TimeEntry(time: "08:30 - 09:15", description: "Welcome"),
    TimeEntry(time: "09:15 - 09:45", description: "Opening"),
    TimeEntry(time: "10:00 - 10:45", description: "Session 1"),
    TimeEntry(time: "10:00 - 11:30", description: "Session 1 - 90 Min."),
    TimeEntry(time: "11:00 - 11:45", description: "Session 2"),
    TimeEntry(time: "11:30 - 14:00", description: "Lunch"),
    TimeEntry(time: "13:00 - 13:45", description: "Session 3"),
    TimeEntry(time: "13:00 - 14:30", description: "Session 3 - 90 Min."),
    TimeEntry(time: "14:00 - 14:45", description: "Session 4"),
    TimeEntry(time: "15:00 - 15:45", description: "Session 5"),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimaryBlue : const Color(0xff8f1910);
    final secondaryColor = isDark ? AppColors.darkMidBlue : const Color(0xffa1392a);

    return Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          backgroundColor: primaryColor,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  return Container(
                    color: index % 2 == 0 ? primaryColor : secondaryColor,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: 160,
                          height: 50,
                          child: Text(
                            entries[index].time,
                            style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        Text(
                          entries[index].description,
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
