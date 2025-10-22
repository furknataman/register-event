import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autumn_conference/db/sharedPreferences/token_stroge.dart';
import 'package:autumn_conference/pages/daily_plan/daily_plan.dart';
import 'package:autumn_conference/pages/start/start_page.dart';
import 'package:autumn_conference/services/service.dart';
import 'package:autumn_conference/theme/theme_extends.dart';
import 'package:autumn_conference/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userDataProvider);
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 15, right: 15),
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 6 * 4,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Image.asset(
                    "assets/images/atc_icon.png",
                    width: 160,
                    height: 120,
                  ),
                  Text(
                    AppLocalizations.of(context)!.conferancesName,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.appColor,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  userData.when(
                    data: ((data) {
                      return Column(
                        children: [
                          Text("${data.name} ${data.surname}",
                              style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(
                            height: 5,
                          ),
                          FittedBox(
                            child: Text(data.job!,
                                style: Theme.of(context).textTheme.displaySmall),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          FittedBox(
                            child: Text(data.school!,
                                style: Theme.of(context).textTheme.displaySmall),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${AppLocalizations.of(context)!.status}: ",
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                              data.generalRollCall ?? false
                                  ? FittedBox(
                                      child: Text(AppLocalizations.of(context)!.canLogin,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700)),
                                    )
                                  : Container(),
                            ],
                          )
                        ],
                      );
                    }),
                    error: (err, stack) => const Text(""),
                    loading: () => const Text(""),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => DailyPlanPage()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(AppLocalizations.of(context)!.dailySchedule,
                                style: Theme.of(context).textTheme.bodyLarge),
                            Icon(
                              Icons.arrow_forward_ios_sharp,
                              color: Theme.of(context).colorScheme.appColor,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      userData.when(
                        data: (data) {
                          return InkWell(
                            onTap: () async {
                              final Uri url = Uri.parse(data.generalForm.toString());
                              if (!await launchUrl(url)) {
                                throw Exception('Could not launch $url');
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(AppLocalizations.of(context)!.generalForm,
                                    style: Theme.of(context).textTheme.bodyLarge),
                                Icon(
                                  Icons.web,
                                  color: Theme.of(context).colorScheme.appColor,
                                  size: 30,
                                ),
                              ],
                            ),
                          );
                        },
                        error: (err, stack) => const Text(""),
                        loading: () => const Text(""),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      InkWell(
                        onTap: () async {
                          logout().then((value) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const StartPage()));
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(AppLocalizations.of(context)!.logout,
                                style: Theme.of(context).textTheme.bodyLarge),
                            Icon(
                              Icons.login,
                              color: Theme.of(context).colorScheme.appColor,
                              size: 30,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ]),
      ),
    );
  }
}
