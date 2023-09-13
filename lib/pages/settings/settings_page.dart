import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr/db/sharedPreferences/token_stroge.dart';
import 'package:qr/theme/theme_extends.dart';
import '../../authentication/login_service.dart';
import '../../global/global_variable/user_info.dart';

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
    //final getGoogle = ref.watch<GoogleProvider>(googleConfig);
    //final userInfo = ref.read<UserInfo>(userInfoConfig);

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
                    "Autumn Teachers Conference",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.appColor,
                        fontSize: 18,
                        fontFamily: 'Raleway'),
                  ),
                ],
              ),
              SizedBox(
                height: 230,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    /*Text(userInfo.user!.name.toString(),
                        style: Theme.of(context).textTheme.titleLarge),*/
                    Text("Eyüboğlu Educational Institutions",
                        style: Theme.of(context).textTheme.displaySmall),
                    /* Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Enable Notifications",
                            style: Theme.of(context).textTheme.bodyLarge),
                      ],
                    ),*/
                    const SizedBox(
                      height: 40,
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Visit TOK Website",
                                style: Theme.of(context).textTheme.bodyLarge),
                            IconButton(
                              icon: Icon(
                                Icons.public,
                                color: Theme.of(context).colorScheme.appColor,
                                size: 30,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Logout", style: Theme.of(context).textTheme.bodyLarge),
                            Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: IconButton(
                                icon: Icon(
                                  Icons.login,
                                  color: Theme.of(context).colorScheme.appColor,
                                  size: 30,
                                ),
                                onPressed: () {
                                  logout();
                                },
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              /* Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("database", style: Theme.of(context).textTheme.bodyLarge),
                  IconButton(
                    icon: const Icon(
                      Icons.login,
                      size: 30,
                    ),
                    onPressed: () {},
                  )
                ],
              )*/
            ]),
      ),
    );
  }
}
