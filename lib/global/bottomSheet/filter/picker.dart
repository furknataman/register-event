import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const List<String> showList = <String>[
  'All',
  'Past Events',
  'Ongoing Events',
  'Registered Events',
];

class CupertinoPickerExample extends StatefulWidget {
  const CupertinoPickerExample({super.key});

  @override
  State<CupertinoPickerExample> createState() => _CupertinoPickerExampleState();
}

class _CupertinoPickerExampleState extends State<CupertinoPickerExample> {
  int _selectedFruit = 0;

  // This shows a CupertinoModalPopup with a reasonable fixed height which hosts CupertinoPicker.
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              // The Bottom margin is provided to align the popup above the system navigation bar.
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              // Provide a background color for the popup.
              color: CupertinoColors.systemBackground.resolveFrom(context),
              // Use a SafeArea widget to avoid system overlaps.
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      // Display a CupertinoPicker with list of fruits.
      onPressed: () => _showDialog(
        CupertinoPicker(
          backgroundColor: Theme.of(context).backgroundColor,
          magnification: 1.22,
          squeeze: 1.2,
          useMagnifier: true,
          itemExtent: 32,
          // This is called when selected item is changed.
          onSelectedItemChanged: (int selectedItem) {
            setState(() {
              _selectedFruit = selectedItem;
            });
          },
          children: List<Widget>.generate(showList.length, (int index) {
            return Center(
              child: Text(
                showList[index],
              ),
            );
          }),
        ),
      ),
      // This displays the selected fruit name.
      child: Text(
        showList[_selectedFruit],
        style: const TextStyle(
          fontSize: 22.0,
        ),
      ),
    );
  }
}
