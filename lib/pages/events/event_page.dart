import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr/db/db_model/db_model_events.dart';
import 'package:qr/global/date_time_converter.dart';
import 'package:qr/pages/events/widgets/skeleton.dart';
import 'package:qr/pages/events/widgets/speakers_info.dart';
import '../../global/global_variable/events_info.dart';
import '../home/widgets/events_cart.dart';

class EventsPage extends ConsumerStatefulWidget {
  final int? eventId;
  const EventsPage(this.eventId, {Key? key}) : super(key: key);

  @override
  ConsumerState<EventsPage> createState() => _EventsPage(eventId: eventId);
}

class _EventsPage extends ConsumerState<EventsPage> {
  int? eventId;
  _EventsPage({@required this.eventId});
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
    AsyncValue<ClassModelEvents> getEventInfo = ref.watch(getEvent("3"));
    //final userInfo = ref.watch<UserInfo>(userInfoConfig);

    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: getEventInfo.when(
            loading: () => const SkelWidget(),
            error: (err, stack) => Text('Error: $err'),
            data: (getEventInfo) {
              ClassTime time =
                  classConverter(getEventInfo.dateTime!, getEventInfo.duration!);
              return CustomScrollView(
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
                            getEventInfo.name.toString(),
                            style: const TextStyle(color: Colors.white, fontSize: 24),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        background: Container(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                              child: Image.network(getEventInfo.imageUrl!,
                                  fit: BoxFit.cover)),
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
                                getEventInfo.name.toString(),
                                style: Theme.of(context).textTheme.displayLarge,
                              ),
                             /* RegisterButton(
                                userInfo: userInfo,
                                event: getEventInfo,
                              ),*/
                            ],
                          ),
                          textContainer(
                              "Date of Event", Theme.of(context).textTheme.displayMedium),
                          textContainer(
                              "${time.month.toString()} ${time.day.toString()}th ${time.clock.toString()}   ",
                              Theme.of(context).textTheme.titleSmall,
                              bottomPadding: 17),
                          textContainer(
                              "Speakers", Theme.of(context).textTheme.displayMedium),
                          speakersInfo(getEventInfo),
                          const SizedBox(
                            height: 17,
                          ),
                          textContainer(
                              "Capacity", Theme.of(context).textTheme.displayMedium),
                          textContainer(
                              "${getEventInfo.capacity! - getEventInfo.participantsNumber!} free seats left from ${getEventInfo.capacity}",
                              Theme.of(context).textTheme.titleSmall,
                              bottomPadding: 17),
                          textContainer(
                              "Description", Theme.of(context).textTheme.displayMedium),
                          textContainer(getEventInfo.description!.toString(),
                              Theme.of(context).textTheme.titleSmall,
                              bottomPadding: 17),
                          /*textContainer("Where is ${getEventInfo.eventsLocation}?",
                              Theme.of(context).textTheme.displayMedium,
                              bottomPadding: 10),*/
                        ],
                      ),
                    ),
                    //LocationWidget(eventLocationlUrl: getEventInfo.eventLocationlUrl),
                    const SizedBox(
                      height: 30,
                    )
                  ])),
                ],
              );
            }));
  }
}
