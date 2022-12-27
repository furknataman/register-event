import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../db/db_model/db_model_events.dart';
import '../../events/event_page.dart';
import '../../../global/date_time_converter.dart';

InkWell evenetsCart(
  BuildContext context, {
  @required String? eventsName,
  @required String? imageUrl,
  @required DateTime? dateTime,
  @required int? eventsNumber,
  @required ClassModelEvents? event,
  @required String? eventLocation,
  @required bool? eventCart,
}) {
  ClassTime time = classConverter(event!.dateTime!, event.duration!);
  return InkWell(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Eventspage(event)));
    },
    child: Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.loose,
        children: [
          Container(
            decoration: const BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.25),
                  blurRadius: 14,
                  offset: Offset(0, 4))
            ], borderRadius: BorderRadius.all(Radius.circular(13))),
            width: MediaQuery.of(context).size.width - 40,
            height: 237,
          ),
          Positioned(
            top: 0,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10), topRight: Radius.circular(10))),
              width: MediaQuery.of(context).size.width - 40,
              height: 166,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(imageUrl!, fit: BoxFit.cover)),
            ),
          ),
          Positioned(
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.only(top: 10, left: 13, right: 13, bottom: 13),
                decoration: const BoxDecoration(
                    color: Color(0xffFFFFFF),
                    borderRadius: BorderRadius.only(
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
                            eventsName!,
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
                            padding: const EdgeInsets.only(left: 6, right: 6),
                            child: Container(
                              alignment: Alignment.center,
                              width: 2,
                              height: 2,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.black),
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
                decoration: const BoxDecoration(
                    color: Color(0xffFFFFFF),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
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
                decoration: const BoxDecoration(
                    color: Color(0xffFFFFFF),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
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
                decoration: const BoxDecoration(
                    color: Color(0xffFFFFFF),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                height: 26,
                width: 60,
                child: Text(
                  eventLocation!,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              )),
        ],
      ),
    ),
  );
}

Container textContainer(String? text, TextStyle? textStyle, {double bottomPadding = 5}) {
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
