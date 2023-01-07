import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:qr/global/global_veriable/user_info.dart';
import 'package:qr/pages/home/widgets/filter/filter.dart';
import 'package:qr/pages/home/widgets/filter/widgets/skeleton.dart';
import '../../global/global_veriable/events_info.dart';
import '../notification/notification.dart';
import 'widgets/events_cart.dart';
import 'widgets/filter/filter_provider.dart';

enum Which { learned, unlearned, all }

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
    AsyncValue<List> allEventsAsync = ref.watch(getEventsList);
    final filterProvider = ref.watch<FilterPage>(alertPageConfig);
    final userInfo = ref.watch<UserInfo>(userInfoConfig);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 24),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome,",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    userInfo.user != null ? userInfo.user!.name.toString() : " ",
                    style: Theme.of(context).textTheme.titleMedium,
                  )
                ],
              ),
              IconButton(
                icon: Icon(
                  HeroiconsOutline.bell,
                  color: Theme.of(context).secondaryHeaderColor,
                  size: 32,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotificationPage()),
                  );
                },
              )
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 19, top: 25, bottom: 5, right: 22),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Upcoming Events",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                IconButton(
                  onPressed: () {
                    filterDialog(context);
                  },
                  icon: Icon(
                    HeroiconsOutline.funnel,
                    color: Theme.of(context).secondaryHeaderColor,
                    size: 30,
                  ),
                )
              ],
            ),
          ),
          allEventsAsync.when(
            loading: () => const SkeletonWidget(),
            error: (err, stack) => Text('Error: $err'),
            data: (allEvents) {
              var filteredEventList = allEvents;

              if (filterProvider.selectedList == 1) {
                filteredEventList = allEvents
                    .where((e) =>
                        e.dateTime.millisecondsSinceEpoch <
                        DateTime.now().millisecondsSinceEpoch)
                    .toList();
              } else if (filterProvider.selectedList == 2) {
                filteredEventList = allEvents
                    .where((e) =>
                        e.dateTime.millisecondsSinceEpoch >
                        DateTime.now().millisecondsSinceEpoch)
                    .toList();
              } else if (filterProvider.selectedList == 3) {
                filteredEventList = allEvents
                    .where((e) => userInfo.user!.registeredEvents!.contains(e.id))
                    .toList();
              }
              if (filterProvider.time != null) {
                filteredEventList = allEvents
                    .where((e) =>
                        e.dateTime.millisecondsSinceEpoch >
                        filterProvider.time!.millisecondsSinceEpoch)
                    .toList();
              }
              filteredEventList.sort((b, a) => b.dateTime.compareTo(a.dateTime));
              return Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    context;
                    return evenetsCart(
                      context,
                      eventCart: userInfo.user!.registeredEvents!
                          .contains(filteredEventList[index].id),
                      event: filteredEventList[index],
                    );
                  },
                  itemCount: filteredEventList.length,
                ),
              );
            },
          ),
        ]),
      ),
    );
  }
}
