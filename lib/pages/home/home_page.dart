import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:qr/global/global_veriable/user_info.dart';
import '../../global/bottomSheet/filter/filter_provider.dart';
import '../../global/global_veriable/events_info.dart';
import '../notification/notification.dart';
import 'widgets/events_cart.dart';

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
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        bottom: true,
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
                    userInfo.user!.name.toString(),
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
                    filterProvider.filterDialog(context, () => Navigator.pop(context), () {
                      Navigator.pop(context);
                    }, "Filters", "Seçili listeler silinecek");
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
          getAllEvents.when(
            loading: () => const CircularProgressIndicator(),
            error: (err, stack) => Text('Error: $err'),
            data: (getAllEvents) {
              return Container(
                color: Colors.transparent,
                height: MediaQuery.of(context).size.height - 250,
                child: Scrollbar(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      context;
                      return evenetsCart(
                        context,
                        eventsNumber: index,
                        eventCart: userInfo.user!.registeredEvents!
                            .contains(getAllEvents[index].id),
                        eventsName: getAllEvents[index].name,
                        imageUrl: getAllEvents[index].imageUrl,
                        dateTime: getAllEvents[index].dateTime,
                        eventLocation: getAllEvents[index].eventsLocation,
                        event: getAllEvents[index],
                      );
                    },
                    itemCount: getAllEvents.length,
                  ),
                ),
              );
            },
          ),
        ]),
      ),
    );
  }
}
