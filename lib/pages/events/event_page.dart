import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qr/db/db_model/db_model_events.dart';
import 'package:qr/global/date_time_converter.dart';
import 'package:qr/global/global_veriable/user_info.dart';

import '../../global/global_veriable/events_info.dart';
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
  ScrollController scrollController = ScrollController();
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      setState(() {
        _isVisible = scrollController.offset > 130;
      });
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final userInfo = ref.watch<UserInfo>(userInfoConfig);

    ClassTime time = classConverter(event!.dateTime!, event!.duration!);
    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.black.withOpacity(0.88),
            pinned: true,
            snap: false,
            floating: false,
            expandedHeight: 220.0,
            flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                title: Visibility(
                  visible: _isVisible,
                  child: Text(
                    event!.name.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                ),
                background: Container(
                  color: Colors.white,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.network(event!.imageUrl!, fit: BoxFit.cover)),
                )),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 17, right: 17),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        event!.name.toString(),
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      RegisterButton(
                        userInfo: userInfo,
                        event: event,
                      ),
                    ],
                  ),
                  textContainer(
                      "Date of Event", Theme.of(context).textTheme.displayMedium),
                  textContainer(
                      "${time.month.toString()} ${time.day.toString()}th ${time.clock.toString()}   ",
                      Theme.of(context).textTheme.titleSmall,
                      bottomPadding: 10),
                  textContainer("Speakers", Theme.of(context).textTheme.displayMedium),
                  SizedBox(
                    height: 30,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        context;
                        return Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                alignment: Alignment.center,
                                width: 2,
                                height: 2,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.black),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              textContainer(event!.speakers![index].toString(),
                                  Theme.of(context).textTheme.titleSmall,
                                  bottomPadding: 10),
                            ],
                          ),
                        );
                      },
                      itemCount: event!.speakers!.length,
                    ),
                  ),
                  textContainer("Cpacity", Theme.of(context).textTheme.displayMedium),
                  textContainer(
                      "${event!.capacity! - event!.participantsNumber!} free seats left from ${event!.capacity}",
                      Theme.of(context).textTheme.titleSmall,
                      bottomPadding: 10),
                  textContainer("Description", Theme.of(context).textTheme.displayMedium),
                  textContainer(event!.description!.toString(),
                      Theme.of(context).textTheme.titleSmall,
                      bottomPadding: 10),
                  textContainer("Where is ${event!.eventsLocation}?",
                      Theme.of(context).textTheme.displayMedium,
                      bottomPadding: 10),
                  LocationWidget(event: event),
                ],
              ),
            ),
          ])),
        ],
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
      ),
    );
  }
}

class RegisterButton extends ConsumerWidget {
  const RegisterButton({
    super.key,
    required this.userInfo,
    required this.event,
  });

  final UserInfo userInfo;
  final ClassModelEvents? event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAction = ref.watch<EventsInfo>(eventsInfoConfig);

    if (event!.capacity! - event!.participantsNumber! == 0) {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff485FFF),
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: const StadiumBorder()),
          onPressed: null,
          child: Row(
            children: [
              Text(
                "Event is Full",
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(
                width: 10,
              ),
              const Icon(
                LucideIcons.calendarX,
                size: 20,
              )
            ],
          ));
    } else if (userInfo.user!.registeredEvents!.contains(event!.id) == false) {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff485FFF),
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: const StadiumBorder()),
          onPressed: () {
            userInfo.writeUser(registeredEvents: event!.id);
            eventAction.writeEvents(event: event);
          },
          child: Row(
            children: const [
              Text(
                "Register",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ));
    } else {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffEB5757),
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: const StadiumBorder()),
          onPressed: () {
            userInfo.removeEvent(registeredEvents: event!.id);
            eventAction.removeEventUser(event: event);
          },
          child: Row(
            children: const [
              Text(
                "Unregister",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Icon(
                LucideIcons.calendarCheck,
                size: 19,
              )
            ],
          ));
    }
  }
}
