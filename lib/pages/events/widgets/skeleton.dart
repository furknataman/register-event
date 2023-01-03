import 'package:flutter/cupertino.dart';
import 'package:skeletons/skeletons.dart';

class SkelWidget extends StatelessWidget {
  const SkelWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SkeletonItem(
            child: Column(
          children: [
            SkeletonAvatar(
              style: SkeletonAvatarStyle(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  width: MediaQuery.of(context).size.width,
                  height: 200),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height - 200,
              width: MediaQuery.of(context).size.width,
              child: SkeletonParagraph(
                  style: SkeletonParagraphStyle(
                      lines: 30,
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
