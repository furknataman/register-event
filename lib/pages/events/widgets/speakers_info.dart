import 'package:flutter/material.dart';

import '../../../db/db_model/db_model_events.dart';
import '../../home/widgets/events_cart.dart';

SizedBox speakersInfo(ClassModelEvents getEventInfo) {
  return SizedBox(
    height: 25,
    child: ListView.separated(
      separatorBuilder: (BuildContext context, int index) => Padding(
        padding: const EdgeInsets.only(left: 6, right: 6, top: 4),
        child: Container(
          alignment: Alignment.center,
          width: 2,
          height: 2,
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: Theme.of(context).secondaryHeaderColor),
        ),
      ),
      reverse: false,
      shrinkWrap: false,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        context;
        return textContainer(getEventInfo.speakers![index].toString(),
            Theme.of(context).textTheme.titleSmall,
            bottomPadding: 0);
      },
      itemCount: getEventInfo.speakers!.length,
    ),
  );
}
