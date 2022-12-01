import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_switch/flutter_switch.dart';

class FilterPage extends ChangeNotifier {
  bool past = true;
  bool ongoing = true;
  void changePost() {
    if (past == true) {
      past = false;
    } else {
      past = true;
    }
    notifyListeners();
  }

  void filterDialog(BuildContext context, Function functionLeft, Function functionRight,
      String titleText, String bodyText) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (BuildContext context, StateSetter mystate) {
            return Container(
              height: 277,
              decoration: const BoxDecoration(
                  color: Color(0xffF2F2F2),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20), topRight: Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18, bottom: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        FractionallySizedBox(
                          widthFactor: 0.25,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 12.0,
                            ),
                            child: Container(
                              height: 5.0,
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(2.5)),
                                  color: Color(0xff828282)),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(titleText,
                              style: Theme.of(context).textTheme.displayLarge),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 90,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /*Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text("Starting from",
                                style: Theme.of(context).textTheme.bodyLarge),
                          ),
                          TimePickerSpinner(
                            is24HourMode: true,
                            normalTextStyle:
                                const TextStyle(fontSize: 24, color: Colors.deepOrange),
                            highlightedTextStyle:
                                const TextStyle(fontSize: 24, color: Colors.yellow),
                            spacing: 50,
                            itemHeight: 80,
                            isForce2Digits: true,
                            onTimeChange: (time) {},
                          ),
                        ],
                      ),*/
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Show Past Events",
                                  style: Theme.of(context).textTheme.bodyLarge),
                              FlutterSwitch(
                                width: 70.0,
                                height: 28.0,
                                toggleSize: 28.0,
                                value: past,
                                inactiveColor: const Color(0xffE0E0E0),
                                activeColor: const Color(0xff485FFF),
                                activeToggleColor: const Color(0xffFFFFFF),
                                inactiveToggleColor: const Color(0xff828282),
                                borderRadius: 14.0,
                                padding: 2.0,
                                showOnOff: false,
                                onToggle: (value) {
                                  mystate(() {
                                    value;
                                  });
                                  changePost();
                                },
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Show Ongoing Events",
                                  style: Theme.of(context).textTheme.bodyLarge),
                              FlutterSwitch(
                                width: 70.0,
                                height: 28.0,
                                toggleSize: 28.0,
                                value: ongoing,
                                inactiveColor: const Color(0xffE0E0E0),
                                activeColor: const Color(0xff485FFF),
                                activeToggleColor: const Color(0xffFFFFFF),
                                inactiveToggleColor: const Color(0xff828282),
                                borderRadius: 14.0,
                                padding: 2.0,
                                showOnOff: false,
                                onToggle: (value) {
                                  mystate(() {
                                    value;
                                  });
                                  changeOngoing();
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffE0E0E0),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 10.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                          ),
                          onPressed: () {
                            functionLeft();
                          },
                          child: const Text(
                            "Reset ",
                            style: TextStyle(
                                fontWeight: FontWeight.w700, color: Color(0xff4F4F4F)),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff485FFF),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 10.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                          ),
                          onPressed: () {
                            functionRight();
                          },
                          child: const Text(
                            "Filter",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  /*FlutterSwitch getSwitch(bool value, Function getFunck) {
    return FlutterSwitch(
      width: 70.0,
      height: 28.0,
      toggleSize: 28.0,
      value: value,
      inactiveColor: const Color(0xffE0E0E0),
      activeColor: const Color(0xff485FFF),
      activeToggleColor: const Color(0xffFFFFFF),
      inactiveToggleColor: const Color(0xff828282),
      borderRadius: 14.0,
      padding: 2.0,
      showOnOff: false,
      onToggle: (val) {
        if (val == true) {
          val = false;
        } else {
          val = true;
        }
        notifyListeners();

        print(val);
        getFunck;
      },
    );
  }*/

  void changeOngoing() {
    if (ongoing == true) {
      ongoing = false;
    } else {
      ongoing = true;
    }
    notifyListeners();
  }
}

final alertPageConfig = ChangeNotifierProvider((ref) => FilterPage());
