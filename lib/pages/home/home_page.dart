import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:qr/global/widgets/internet_control.dart';
import 'package:qr/pages/home/widgets/filter/filter.dart';
import 'package:qr/pages/home/widgets/filter/widgets/skeleton.dart';
import 'package:qr/services/service.dart';
import 'package:qr/theme/theme_extends.dart';
import 'widgets/events_cart.dart';
import 'widgets/filter/filter_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

bool isAfter(TimeOfDay first, TimeOfDay second) {
  return first.hour > second.hour ||
      (first.hour == second.hour && first.minute > second.minute);
}

class Homepage extends ConsumerStatefulWidget {
  const Homepage({super.key});

  @override
  ConsumerState<Homepage> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userDataProvider);
    final eventData = ref.watch(presentationDataProvider);

    final filterProvider = ref.watch<FilterPage>(alertPageConfig);
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            color: Theme.of(context).colorScheme.mainColor,
            child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 15, top: 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.hi,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                userData.when(
                                  loading: () => const Text(""),
                                  data: ((data) {
                                    return Text("${data.name} ${data.surname}");
                                  }),
                                  error: (err, stack) => const Text(" "),
                                )
                              ],
                            ),
                            /*IconButton(
                              icon: const Icon(
                                HeroiconsOutline.bell,
                                color: Colors.white,
                                size: 32,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const NotificationPage()),
                                );
                              },
                            )*/
                          ]),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 19, top: 25, bottom: 5, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.upcoming,
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          filterProvider.selectedList == 0 &&
                                  filterProvider.time == null &&
                                  filterProvider.selectedBranch == 0 &&
                                  filterProvider.selectedTarget == 0
                              ? IconButton(
                                  onPressed: () {
                                    filterDialog(context);
                                  },
                                  icon: const Icon(
                                    HeroiconsOutline.funnel,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                )
                              : IconButton(
                                  onPressed: () {
                                    filterDialog(context);
                                  },
                                  icon: const Icon(
                                    HeroiconsSolid.funnel,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                )
                        ],
                      ),
                    ),
                  ],
                )),
          ),
          eventData.when(
            error: (err, stack) => internetControl(context, ref),
            loading: () => const SkeletonWidget(),
            data: (allEvents) {
              return userData.when(
                  data: ((data) {
                    var filteredEventList = allEvents;

                    if (filterProvider.selectedList == 3) {
                      filteredEventList = filteredEventList.where((e) {
                        if (data.registeredEventId == null || e.id == null) {
                          return false; // Eğer herhangi bir değer null ise bu elemanı listeye almıyoruz.
                        }
                        return data.registeredEventId!.contains(e.id);
                      }).toList();
                    } else if (filterProvider.selectedList == 2) {
                      filteredEventList = filteredEventList
                          .where((e) =>
                              e.presentationTime!.millisecondsSinceEpoch >
                              DateTime.now().millisecondsSinceEpoch)
                          .toList();
                    } else if (filterProvider.selectedList == 1) {
                      filteredEventList = filteredEventList
                          .where((e) =>
                              e.presentationTime!.millisecondsSinceEpoch <
                              DateTime.now().millisecondsSinceEpoch)
                          .toList();
                    }

                    if (filterProvider.selectedBranch != 0) {
                      filteredEventList = filteredEventList
                          .where((element) => element.branch!.contains(
                              filterProvider.branchList[filterProvider.selectedBranch]))
                          .toList();
                    }
                    if (filterProvider.selectedTarget != 0) {
                      filteredEventList = filteredEventList
                          .where((element) => element.audience!.contains(
                              filterProvider.targetList[filterProvider.selectedTarget]))
                          .toList();
                    }

                    if (filterProvider.time != null) {
                      filteredEventList = filteredEventList
                          .where((e) =>
                              e.presentationTime!.millisecondsSinceEpoch >
                              filterProvider.time!.millisecondsSinceEpoch)
                          .toList();
                    }
                    return Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 10),
                        itemBuilder: (context, index) {
                          context;
                          return eventsCart(
                            context,
                            eventCart: (data.registeredEventId
                                    ?.contains(filteredEventList[index].id) ??
                                false),
                            event: filteredEventList[index],
                          );
                        },
                        itemCount: filteredEventList.length,
                      ),
                    );
                  }),
                  error: (err, stack) => const Text(" "),
                  loading: () => const Text(""));
            },
          )
        ]));
  }
}
