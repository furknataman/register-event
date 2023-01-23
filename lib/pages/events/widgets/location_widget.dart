import 'package:flutter/material.dart';

class LocationWidget extends StatelessWidget {
  const LocationWidget({
    super.key,
    required this.eventLocationUrl,
  });

  final String? eventLocationUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10.0, left: 17, right: 17),
      width: MediaQuery.of(context).size.width,
      color: const Color.fromARGB(255, 226, 224, 224),
      child: Image(
        fit: BoxFit.fitHeight,
        image: NetworkImage(
          eventLocationUrl!,
        ),
      ),
    );
  }
}
