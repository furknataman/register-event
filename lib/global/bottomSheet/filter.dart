import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

void filterDialog(BuildContext context, Function functionLeft, Function functionRight,
    String titleText, String bodyText) {
  showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) {
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
                      child:
                          Text(titleText, style: Theme.of(context).textTheme.displayLarge),
                    ),
                  ],
                ),
                SizedBox(
                  height: 90,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text("Starting from",
                                style: Theme.of(context).textTheme.bodyLarge),
                          ),
                          /*FloatingActionButton(onPressed: () {
                           showCupertinoDialog( CupertinoDatePicker(
                              initialDateTime: DateTime.now(),
                              mode: CupertinoDatePickerMode.time,
                              use24hFormat: true,
                              // This is called when the user changes the time.
                              onDateTimeChanged: (DateTime newTime) {},
                            ); )  
                          })*/
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Show Past Events",
                              style: Theme.of(context).textTheme.bodyLarge),
                          FlutterSwitch(
                            width: 70.0,
                            height: 28.0,
                            toggleSize: 28.0,
                            value: false,
                            inactiveColor: const Color(0xffE0E0E0),
                            activeColor: const Color(0xff485FFF),
                            activeToggleColor: const Color(0xffFFFFFF),
                            inactiveToggleColor: const Color(0xff828282),
                            borderRadius: 14.0,
                            padding: 2.0,
                            showOnOff: false,
                            onToggle: (val) {},
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
                            value: true,
                            inactiveColor: const Color(0xffE0E0E0),
                            activeColor: const Color(0xff485FFF),
                            activeToggleColor: const Color(0xffFFFFFF),
                            inactiveToggleColor: const Color(0xff828282),
                            borderRadius: 14.0,
                            padding: 2.0,
                            showOnOff: false,
                            onToggle: (val) {},
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton.extended(
                      backgroundColor: const Color(0xffE0E0E0),
                      onPressed: () {
                        functionLeft();
                      },
                      label: const Text(
                        "Reset ",
                        style: TextStyle(
                            fontWeight: FontWeight.w700, color: Color(0xff4F4F4F)),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    FloatingActionButton.extended(
                      backgroundColor: const Color(0xff485FFF),
                      onPressed: () {
                        functionRight();
                      },
                      label: const Text(
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
}
