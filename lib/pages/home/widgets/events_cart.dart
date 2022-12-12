import 'package:flutter/material.dart';
import '../../../db/db_model/db_model_events.dart';
import '../../../events/events.dart';
import '../../../global/date_time_converter.dart';

InkWell evenetsCart(
  BuildContext context, {
  @required String? eventsName,
  @required String? imageUrl,
  @required DateTime? dateTime,
  @required int? eventsNumber,
  @required ClassModelEvents? event,
  @required String? eventLocation,
}) {
  ClassTime time = classConverter(event!.dateTime!);
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
              width: MediaQuery.of(context).size.width - 40,
              height: 166,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                        imageUrl!,
                      ),
                      fit: BoxFit.fill),
                  color: Colors.black,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15), topRight: Radius.circular(15))),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            "13:40 - 14:00",
                            style: Theme.of(context).textTheme.displayMedium,
                          )
                        ],
                      ),
                      Text(
                        eventLocation!,
                        style: Theme.of(context).textTheme.displaySmall,
                      )
                    ]),
              )),
          Positioned(
              top: 13,
              left: 26,
              child: Container(
                decoration: const BoxDecoration(
                    color: Color(0xffFFFFFF),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
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
              right: 26,
              child: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(72, 95, 255, 0.5),
                          blurRadius: 14,
                          offset: Offset(0, 4))
                    ],
                    color: Color(0xffFFFFFF),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                height: 26,
                width: 72,
                child: Text("Ongoing", style: Theme.of(context).textTheme.labelMedium),
              )),
        ],
      ),
    ),
  );
}
