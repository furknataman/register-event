import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  @override
  Widget build(BuildContext context) {
    return PhotoView(
      imageProvider: const AssetImage('assets/images/maps.jpg'),
    );
  }
}
