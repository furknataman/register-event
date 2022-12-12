import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:qr/db/db_model/db_model_events.dart';
import 'package:qr/events/events.dart';
import 'package:qr/global/global_veriable/user_info.dart';
import '../../global/bottomSheet/filter/filter_provider.dart';
import '../../global/global_veriable/events_info.dart';

class Homepage extends ConsumerStatefulWidget {
  const Homepage({super.key});

  @override
  ConsumerState<Homepage> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {
  @override
  void initState() {
    super.initState();
    ref.read<UserInfo>(userInfoConfig).readUser();
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<List> getAllEvents = ref.watch(getEventsList);
    final filterProvider = ref.watch<FilterPage>(alertPageConfig);
    final userInfo = ref.watch<UserInfo>(userInfoConfig);
    return Scaffold(
      body: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 34, top: 3),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome,",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    userInfo.user!.name.toString(),
                    style: Theme.of(context).textTheme.titleMedium,
                  )
                ],
              ),
              IconButton(
                icon: const Icon(
                  HeroiconsOutline.bell,
                  color: Color(0xff333333),
                  size: 34,
                ),
                onPressed: () {},
              )
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 19, top: 25, bottom: 5, right: 34),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Upcoming Events",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                IconButton(
                  onPressed: () {
                    filterProvider.filterDialog(context, () => Navigator.pop(context), () {
                      Navigator.pop(context);
                    }, "Filters", "Seçili listeler silinecek");
                  },
                  icon: const Icon(
                    HeroiconsOutline.funnel,
                    color: Color(0xff333333),
                    size: 30,
                  ),
                )
              ],
            ),
          ),
          getAllEvents.when(
            loading: () => const CircularProgressIndicator(),
            error: (err, stack) => Text('Error: $err'),
            data: (getAllEvents) {
              return Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    context;
                    return actionStac(
                        eventsNumber: index,
                        eventsName: getAllEvents[index].name,
                        imageUrl: getAllEvents[index].imageUrl,
                        dateTime: getAllEvents[index].dateTime,
                        eventLocation: getAllEvents[index].eventsLocation,
                        event: getAllEvents[index]);
                  },
                  itemCount: getAllEvents.length,
                ),
              );
            },
          )
        ]),
      ),
    );
  }

  InkWell actionStac({
    @required String? eventsName,
    @required String? imageUrl,
    @required DateTime? dateTime,
    @required int? eventsNumber,
    @required ClassModelEvents? event,
    @required String? eventLocation,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Eventspage(event!)));
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
                  height: 38,
                  width: 38,
                  child: Column(
                    children: [
                      Text("14", style: Theme.of(context).textTheme.labelLarge),
                      Text("Ara", style: Theme.of(context).textTheme.labelSmall)
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
}
