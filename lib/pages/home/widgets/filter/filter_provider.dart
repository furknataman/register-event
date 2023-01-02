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
  int selectedList = 0;

  void changeListShow(int i) {
    selectedList = i;
    notifyListeners();
  }

  void changeListTime(DateTime i) {
    time = i;
    notifyListeners();
  }

  void reset() {
    time = null;
    selectedList = 0;
    notifyListeners();
  }

  void showDialog(context, Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10), topRight: Radius.circular(10))),
              height: 216,
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
