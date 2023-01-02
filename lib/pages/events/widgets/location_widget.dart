import 'package:flutter/material.dart';
import '../../../db/db_model/db_model_events.dart';

class LocationWidget extends StatelessWidget {
  const LocationWidget({
    super.key,
    required this.eventLocationUrl,
  });

  final String? eventLocationUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 34,
      height: 300,
      decoration: BoxDecoration(
          image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.75), BlendMode.dstATop),
              image: NetworkImage(
                eventLocationUrl!,
              ),
              fit: BoxFit.fitHeight),
          color: Colors.black,
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15))),
    );
  }
}