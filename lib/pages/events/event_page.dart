import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr/db/db_model/db_model_events.dart';
import 'package:qr/global/date_time_converter.dart';
import 'package:qr/global/global_veriable/user_info.dart';

import 'widgets/location_widget.dart';

class Eventspage extends ConsumerStatefulWidget {
  final ClassModelEvents? event;
  const Eventspage(this.event, {Key? key}) : super(key: key);

  @override
  ConsumerState<Eventspage> createState() => _Eventspage(event: event);
}

class _Eventspage extends ConsumerState<Eventspage> {
  ClassModelEvents? event;
  _Eventspage({@required this.event});
  String? timeData;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final userInfo = ref.watch<UserInfo>(userInfoConfig);
    ClassTime time = classConverter(event!.dateTime!, event!.duration!);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      floatingActionButton: IconButton(
        icon: const Icon(
          Icons.arrow_circle_left_outlined,
          color: Colors.white,
          size: 40,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 300,
            decoration: BoxDecoration(
                image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Colors.white.withOpacity(0.75), BlendMode.dstATop),
                    image: NetworkImage(
                      event!.imageUrl!,
                    ),
                    fit: BoxFit.fitHeight),
                color: Colors.black,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 23.0, left: 17, right: 17),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          event!.name.toString(),
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff485FFF),
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 10, bottom: 10),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                shape: const StadiumBorder()),
                            onPressed: () {
                              userInfo.writeUser(registeredEvents: 121212);
                            },
                            child: Row(
                              children: const [
                                Text("Register"),
                              ],
                            )),
                      ],
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(top: 17, bottom: 17),
                      child: Text(
                        "${time.month.toString()} ${time.day.toString()}th ${time.clock.toString()}   ",
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(top: 17, bottom: 17),
                      child: Text(
                        event!.description!.toString(),
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(top: 17, bottom: 17),
                      child: Text(
                        "Where is ${event!.eventsLocation}?",
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ),
                    LocationWidget(event: event),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
