import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

const List<String> showList = <String>[
  'All',
  'Past Events',
  'Ongoing Events',
  'Registered Events',
];

class Picker extends StatefulWidget {
  const Picker({super.key});

  @override
  State<Picker> createState() => _PickerState();
}

class _PickerState extends State<Picker> {
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
              color: Theme.of(context).backgroundColor,
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
      child: Container(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 4),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Theme.of(context).secondaryHeaderColor,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(14),
          ),
        ),
        child: Row(
          children: [
            Text(showList[_selectedFruit], style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(
              width: 6,
            ),
            Icon(
              LucideIcons.chevronsUpDown,
              color: Theme.of(context).secondaryHeaderColor,
            )
          ],
        ),
      ),
    );
  }
}
