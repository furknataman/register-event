import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LocationWidget extends StatelessWidget {
  const LocationWidget({
    super.key,
    required this.eventLocationlUrl,
  });

  final String? eventLocationlUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 10.0, left: 17, right: 17),
        width: MediaQuery.of(context).size.width,
        color: const Color.fromARGB(255, 226, 224, 224),
        child: Image.network(eventLocationlUrl!, fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          } else {
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: MediaQuery.of(context).size.width - 20,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          }
        }));
  }
}
