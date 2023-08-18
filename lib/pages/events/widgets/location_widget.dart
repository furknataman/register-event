import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

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
            return SkeletonItem(
              child: SkeletonAvatar(
                style: SkeletonAvatarStyle(
                    width: MediaQuery.of(context).size.width - 20, height: 200),
              ),
            );
          }
        }));
  }
}
