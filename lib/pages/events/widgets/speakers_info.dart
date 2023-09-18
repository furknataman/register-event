import 'package:flutter/material.dart';
import 'package:qr/db/db_model/Presentation.model.dart';

Widget speakersInfo(BuildContext context, Presentation getEventInfo) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      FittedBox(
        child: Text(
          getEventInfo.presenter1Name!,
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
      getEventInfo.presenter2Name != null
          ? Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 6, right: 6, top: 8),
                  alignment: Alignment.center,
                  width: 2,
                  height: 2,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).secondaryHeaderColor),
                ),
                FittedBox(
                  child: Text(
                    getEventInfo.presenter2Name.toString(),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                )
              ],
            )
          : Container(),
    ],
  );
}
