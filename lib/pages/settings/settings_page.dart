import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr/db/sharedPreferences/token_stroge.dart';
import 'package:qr/pages/start/start_page.dart';
import 'package:qr/services/service.dart';
import 'package:qr/theme/theme_extends.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
                          data.generalRollCall ?? false
                              ? FittedBox(
                                  child: Text(data.generalRollCall!.toString(),
                                      style: Theme.of(context).textTheme.displaySmall),
                                )
                              : Container(),
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
                      userData.when(
                        data: (data) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(AppLocalizations.of(context)!.logout,
                                  style: Theme.of(context).textTheme.bodyLarge),
                              Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.web,
                                    color: Theme.of(context).colorScheme.appColor,
                                    size: 30,
                                  ),
                                  onPressed: () async {
                                    final Uri url = Uri.parse(data.generalForm.toString());
                                    if (!await launchUrl(url)) {
                                      throw Exception('Could not launch $url');
                                    }
                                    ;
                                  },
                                ),
                              )
                            ],
                          );
                        },
                        error: (err, stack) => const Text(""),
                        loading: () => const Text(""),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppLocalizations.of(context)!.logout,
                              style: Theme.of(context).textTheme.bodyLarge),
                          Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: IconButton(
                              icon: Icon(
                                Icons.login,
                                color: Theme.of(context).colorScheme.appColor,
                                size: 30,
                              ),
                              onPressed: () async {
                                logout().then((value) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const StartPage()));
                                });
                              },
                            ),
                          )
                        ],
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
