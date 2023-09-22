import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr/global/date_time_converter.dart';
import 'package:qr/global/widgets/internet_control.dart';
import 'package:qr/pages/events/widgets/register_button.dart';
import 'package:qr/pages/events/widgets/skeleton.dart';
import 'package:qr/pages/events/widgets/speakers_info.dart';
import 'package:qr/services/service.dart';
import 'package:qr/theme/theme_extends.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    ref.invalidate(userDataProvider);
    ref.invalidate(eventDetailsProvider(eventId!));
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final getEventInfo = ref.watch(eventDetailsProvider(eventId!));
    final userData = ref.watch(userDataProvider);
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: getEventInfo.when(
            loading: () => const SkelWidget(),
            error: (err, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'An error occurred. Can you try again?',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      IconButton(
                          onPressed: () async {
                            ref.invalidate(userDataProvider);
                            ref.invalidate(eventDetailsProvider(eventId!));
                          },
                          icon: const Icon(Icons.restart_alt))
                    ],
                  ),
                ),
            data: (getEventInfo) {
              int duration = int.parse(getEventInfo!.duration ?? "0");
              ClassTime time = classConverter(getEventInfo.presentationTime!, duration);
              return CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    backgroundColor: Theme.of(context).colorScheme.appColor,
                    pinned: true,
                    snap: false,
                    floating: false,
                    expandedHeight: 220.0,
                    flexibleSpace: FlexibleSpaceBar(
                        collapseMode: CollapseMode.pin,
                        title: Visibility(
                          visible: false,
                          child: Text(
                            "${time.clock} : ${time.endTime}",
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
                              child: Image.network(
                                  "https://images.unsplash.com/photo-1509228468518-180dd4864904?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2340&q=80",
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
                              Flexible(
                                child: Column(
                                  children: [
                                    Text(
                                        textAlign: TextAlign.start,
                                        getEventInfo.title.toString(),
                                        style: Theme.of(context).textTheme.displayMedium,
                                        overflow: TextOverflow.visible),
                                  ],
                                ),
                              ),
                              Container()
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          userData.when(
                            loading: () => const Text(""),
                            data: ((data) {
                              return RegisterButton(
                                event: getEventInfo,
                                userInfo: data,
                                eventId: eventId!,
                              );
                            }),
                            error: (err, stack) => internetControl(context, ref),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          textContainer(
                              "Date of Event", Theme.of(context).textTheme.displayMedium),
                          textContainer("${time.clock} : ${time.endTime}",
                              Theme.of(context).textTheme.titleSmall,
                              bottomPadding: 17),
                          textContainer(
                              "Speakers", Theme.of(context).textTheme.displayMedium),
                          speakersInfo(context, getEventInfo),
                          const SizedBox(
                            height: 17,
                          ),
                          textContainer(
                              "Capacity", Theme.of(context).textTheme.displayMedium),
                          textContainer(
                              "${getEventInfo.remainingQuota} free seats left from ${getEventInfo.presentationQuota}",
                              Theme.of(context).textTheme.titleSmall,
                              bottomPadding: 17),
                          textContainer(
                              "Description", Theme.of(context).textTheme.displayMedium),
                          textContainer(getEventInfo.description.toString(),
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
