import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr/db/db_model/db_model_events.dart';
import 'package:qr/global/date_time_converter.dart';
import 'package:qr/global/global_veriable/events_info.dart';
import 'package:qr/global/global_veriable/user_info.dart';
import 'package:qr/pages/events/widgets/register_button.dart';
import 'package:qr/pages/events/widgets/skeleton.dart';
import 'package:qr/pages/events/widgets/speakers_info.dart';
import '../home/widgets/events_cart.dart';
import 'widgets/location_widget.dart';

class Eventspage extends ConsumerStatefulWidget {
  final String? eventname;
  const Eventspage(this.eventname, {Key? key}) : super(key: key);

  @override
  ConsumerState<Eventspage> createState() => _Eventspage(eventname: eventname);
}

class _Eventspage extends ConsumerState<Eventspage> {
  String? eventname;
  _Eventspage({@required this.eventname});
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
    AsyncValue<ClassModelEvents> getEventInfo = ref.watch(getEvent(eventname.toString()));
    final userInfo = ref.watch<UserInfo>(userInfoConfig);

    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
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
                          color: Theme.of(context).backgroundColor,
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
                              RegisterButton(
                                userInfo: userInfo,
                                event: getEventInfo,
                              ),
                            ],
                          ),
                          textContainer(
                              "Date of Event", Theme.of(context).textTheme.displayMedium),
                          textContainer(
                              "${time.month.toString()} ${time.day.toString()}th ${time.clock.toString()}   ",
                              Theme.of(context).textTheme.titleSmall,
                              bottomPadding: 10),
                          textContainer(
                              "Speakers", Theme.of(context).textTheme.displayMedium),
                          speakersInfo(getEventInfo),
                          const SizedBox(
                            height: 10,
                          ),
                          textContainer(
                              "Capacity", Theme.of(context).textTheme.displayMedium),
                          textContainer(
                              "${getEventInfo.capacity! - getEventInfo.participantsNumber!} free seats left from ${getEventInfo.capacity}",
                              Theme.of(context).textTheme.titleSmall,
                              bottomPadding: 10),
                          textContainer(
                              "Description", Theme.of(context).textTheme.displayMedium),
                          textContainer(getEventInfo.description!.toString(),
                              Theme.of(context).textTheme.titleSmall,
                              bottomPadding: 10),
                          textContainer("Where is ${getEventInfo.eventsLocation}?",
                              Theme.of(context).textTheme.displayMedium,
                              bottomPadding: 10),
                          LocationWidget(eventLocationUrl: getEventInfo.eventLocationlUrl),
                        ],
                      ),
                    ),
                  ])),
                ],
              );
            }));
  }
}
