import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Eventspage extends ConsumerStatefulWidget {
  final int? eventsNumber;
  const Eventspage(this.eventsNumber, {Key? key}) : super(key: key);

  @override
  ConsumerState<Eventspage> createState() => _Eventspage(eventsNumber: eventsNumber);
}

class _Eventspage extends ConsumerState<Eventspage> {
  int? eventsNumber;
  String? listName;
  _Eventspage({@required this.eventsNumber});
  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      body: Container(
          child: Text(
        eventsNumber.toString(),
        style: TextStyle(color: Colors.black, fontSize: 50),
      )),
    );
  }
}
