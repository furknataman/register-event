import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilterPage extends ChangeNotifier {
  String defaultText = "All";
  DateTime? time;
  List<String> showList = <String>[
    'All',
    'Past Events',
    'Ongoing Events',
    'Registered Events',
  ];
  List<String> targetList = <String>[
    'All',
    'Kindergarten',
    'Elementary School ',
    'Middle School',
    'High School',
    'K12'
  ];
  List<String> branchList = <String>[
    'All',
    'BIOLOGY',
    'CHEMISTRY',
    'ENGLISH',
    'FOREIGN LANGUAGES',
    'GENERAL EDUCATION',
    'GEOGRAPHY',
    'GUIDANCE',
    'HISTORY',
    'IB DP',
    'IB MYP',
    'IB PYP',
    'INTERDISCIPLINARY',
    'Information Technology',
    'KINDERGARDEN',
    'LIBRARY',
    'MANAGEMENT AND LEADERSHIP',
    'MATHS',
    'MUSIC',
    'PE',
    'PHILOSOPHY',
    'PHYSICS',
    'SCIENCE',
    'SOCIAL STUDIES',
    'TURKISH LANGUAGE AND LITERATURE',
    'VISUAL ARTS'
  ];
  void filterNameUpdated(BuildContext context) {}
  int selectedList = 0;
  int selectedBranch = 0;
  int selectedTarget = 0;

  void changeListShow(int i) {
    selectedList = i;
    notifyListeners();
  }

  void changeListTarget(int i) {
    selectedTarget = i;
    notifyListeners();
  }

  void changeListBranch(int i) {
    selectedBranch = i;
    notifyListeners();
  }

  void changeListTime(DateTime i) {
    time = i;
    notifyListeners();
  }

  void reset() {
    time = null;
    selectedList = 0;
    selectedTarget = 0;
    selectedBranch = 0;
    notifyListeners();
  }

  void showDialog(context, Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10), topRight: Radius.circular(10))),
              height: 250,
              padding: const EdgeInsets.only(top: 6.0),
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }
}

final alertPageConfig = ChangeNotifierProvider((ref) => FilterPage());
