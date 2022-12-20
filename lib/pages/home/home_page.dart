import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:qr/global/global_veriable/user_info.dart';
import '../../global/bottomSheet/filter/filter_provider.dart';
import '../../global/global_veriable/events_info.dart';
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
              );
            },
          )
        ]),
      ),
    );
  }
}
