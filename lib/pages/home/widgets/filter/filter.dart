import 'package:flutter/material.dart';
import 'package:qr/main.dart';
import 'package:qr/pages/home/widgets/filter/widgets/show_picker.dart';
import 'package:qr/pages/home/widgets/filter/widgets/time_picker.dart';

void filterDialog(BuildContext context, Function functionLeft, Function functionRight,
    String titleText, String bodyText) {
  showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: 277,
          decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: const BorderRadius.only(
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
                          Text("Starting from",
                              style: Theme.of(context).textTheme.bodyLarge),
                          const DatePickerExample()
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("What to show",
                              style: Theme.of(context).textTheme.bodyLarge),
                          const Picker(),
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
                        backgroundColor: Theme.of(context).colorScheme.disable,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                      ),
                      onPressed: () {
                        functionLeft();
                      },
                      child: Text("Reset ", style: Theme.of(context).textTheme.labelLarge),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).floatingActionButtonTheme.backgroundColor,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
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
}
