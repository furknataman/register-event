import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr/global/date_time_converter.dart';
import 'package:qr/global/widgets/internet_control.dart';
import 'package:qr/pages/events/widgets/register_button.dart';
import 'package:qr/pages/events/widgets/skeleton.dart';
import 'package:qr/pages/events/widgets/speakers_info.dart';
import 'package:qr/services/service.dart';
import 'package:qr/theme/theme_extends.dart';
import 'package:url_launcher/url_launcher.dart';
import '../home/widgets/events_cart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EventsPage extends ConsumerStatefulWidget {
  final int? eventId;
  final String? evetImageName;
  const EventsPage(this.eventId, this.evetImageName, {Key? key}) : super(key: key);

  @override
  ConsumerState<EventsPage> createState() =>
      _EventsPage(eventId: eventId, evetImageName: evetImageName);
}

class _EventsPage extends ConsumerState<EventsPage> {
  int? eventId;
  final String? evetImageName;
  _EventsPage({@required this.eventId, @required this.evetImageName});
  String? timeData;

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
                        AppLocalizations.of(context)!.connectionError,
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
                              child: Image.asset(evetImageName!, fit: BoxFit.cover)),
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
                          textContainer(AppLocalizations.of(context)!.timeOfEvent,
                              Theme.of(context).textTheme.displayMedium),
                          textContainer("${time.clock} : ${time.endTime}",
                              Theme.of(context).textTheme.titleSmall,
                              bottomPadding: 17),
                          textContainer(AppLocalizations.of(context)!.speakers,
                              Theme.of(context).textTheme.displayMedium),
                          speakersInfo(context, getEventInfo),
                          const SizedBox(
                            height: 17,
                          ),
                          textContainer(AppLocalizations.of(context)!.capacity,
                              Theme.of(context).textTheme.displayMedium),
                          textContainer(
                              AppLocalizations.of(context)!.freeSeats(
                                getEventInfo.presentationQuota.toString(),
                                getEventInfo.remainingQuota.toString(),
                              ),
                              Theme.of(context).textTheme.titleSmall,
                              bottomPadding: 17),
                          textContainer(AppLocalizations.of(context)!.eventLocation,
                              Theme.of(context).textTheme.displayMedium),
                          textContainer(getEventInfo.presentationPlace,
                              Theme.of(context).textTheme.titleSmall,
                              bottomPadding: 17),
                          textContainer(AppLocalizations.of(context)!.description,
                              Theme.of(context).textTheme.displayMedium),
                          textContainer(getEventInfo.description.toString(),
                              Theme.of(context).textTheme.titleSmall,
                              bottomPadding: 17),
                          userData.when(
                            loading: () => const Text(""),
                            data: ((data) {
                              if (data.attendedToEventId?.contains(eventId) ?? false) {
                                return ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff485FFF),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    shape: const StadiumBorder(),
                                  ),
                                  onPressed: () async {
                                    final Uri url = Uri.parse(getEventInfo.ratingForm!);
                                    if (!await launchUrl(url)) {
                                      throw Exception('Could not launch $url');
                                    }
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.appRate,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            }),
                            error: (err, stack) => internetControl(context, ref),
                          ),
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
