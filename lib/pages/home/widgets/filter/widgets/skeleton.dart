import 'package:flutter/cupertino.dart';
import 'package:skeletons/skeletons.dart';

class SkeletonWidget extends StatelessWidget {
  const SkeletonWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SkeletonItem(
        child: Column(
      children: [
        SkeletonAvatar(
          style: SkeletonAvatarStyle(
              width: MediaQuery.of(context).size.width - 20, height: 200),
        ),
        SizedBox(
          height: 200,
          width: MediaQuery.of(context).size.width - 20,
          child: SkeletonParagraph(
              style: SkeletonParagraphStyle(
                  lines: 3,
                  spacing: 6,
                  lineStyle: SkeletonLineStyle(
                    randomLength: true,
                    height: 10,
                    borderRadius: BorderRadius.circular(8),
                    minLength: MediaQuery.of(context).size.width / 2,
                  ))),
        ),
      ],
    ));
  }
}