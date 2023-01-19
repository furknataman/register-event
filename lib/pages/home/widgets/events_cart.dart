import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:skeletons/skeletons.dart';
import '../../../db/db_model/db_model_events.dart';
import '../../events/event_page.dart';
import '../../../global/date_time_converter.dart';

InkWell evenetsCart(
  BuildContext context, {
  @required ClassModelEvents? event,
  @required bool? eventCart,
}) {
  ClassTime time = classConverter(event!.dateTime!, event.duration!);
  return InkWell(
    onTap: () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Eventspage(event.eventsCollentionName)));
    },
    child: Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.loose,
        children: [
          Container(
            decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.15),
                      blurRadius: 14,
                      offset: Offset(0, 4))
                ],
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(13))),
            width: MediaQuery.of(context).size.width - 40,
            height: 237,
          ),
          Positioned(
            top: 0,
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10), topRight: Radius.circular(10))),
              width: MediaQuery.of(context).size.width - 40,
              height: 166,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(event.imageUrl!, fit: BoxFit.cover,
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
                  })),
            ),
          ),
          Positioned(
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.only(top: 10, left: 13, right: 13, bottom: 13),
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10))),
                height: 71,
                width: MediaQuery.of(context).size.width - 40,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            event.name!,
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          Text(
                            "${time.clock} : ${time.endTime}",
                            style: Theme.of(context).textTheme.displayMedium,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 25,
                        child: ListView.separated(
                          separatorBuilder: (BuildContext context, int index) => Padding(
                            padding: const EdgeInsets.only(left: 6, right: 6, top: 4),
                            child: Container(
                              alignment: Alignment.center,
                              width: 2,
                              height: 2,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).secondaryHeaderColor),
                            ),
                          ),
                          reverse: false,
                          shrinkWrap: false,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            context;
                            return textContainer(event.speakers![index].toString(),
                                Theme.of(context).textTheme.titleSmall,
                                bottomPadding: 0);
                          },
                          itemCount: event.speakers!.length,
                        ),
                      ),
                    ]),
              )),
          Positioned(
              top: 13,
              left: 30,
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                height: 42,
                width: 42,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(time.day.toString(),
                        style: Theme.of(context).textTheme.labelLarge),
                    Text(time.shortMonth.toString(),
                        style: Theme.of(context).textTheme.labelSmall)
                  ],
                ),
              )),
          Positioned(
              top: 13,
              right: 30,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                height: 38,
                width: 38,
                child: eventCart!
                    ? const Icon(
                        LucideIcons.calendarCheck,
                        size: 28,
                        color: Color(0xff485FFF),
                      )
                    : const Icon(LucideIcons.calendar, size: 28, color: Color(0xffBDBDBD)),
              )),
          Positioned(
              bottom: 80,
              left: 30,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                height: 26,
                width: 60,
                child: Text(
                  event.eventsLocation!,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              )),
        ],
      ),
    ),
  );
}

Container textContainer(String? text, TextStyle? textStyle, {double bottomPadding = 1}) {
  return Container(
    alignment: Alignment.centerLeft,
    padding: EdgeInsets.only(bottom: bottomPadding),
    child: Text(
      text!,
      style: textStyle,
      textAlign: TextAlign.start,
    ),
  );
}
