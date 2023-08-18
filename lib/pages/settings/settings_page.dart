import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../authentication/login_service.dart';
import '../../global/global_variable/user_info.dart';
import '../../global/svg.dart';

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
    final getGoogle = ref.watch<GoogleProvider>(googleConfig);
    final userInfo = ref.read<UserInfo>(userInfoConfig);

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 30, right: 30),
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 6 * 4,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  logo2,
                  const Text(
                    "Theory of Knowledge",
                    style: TextStyle(
                        color: Color(0xff485FFF), fontSize: 18, fontFamily: 'Raleway'),
                  ),
                ],
              ),
              SizedBox(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(userInfo.user!.name.toString(),
                        style: Theme.of(context).textTheme.titleLarge),
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
                      height: 30,
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Visit TOK Website",
                                style: Theme.of(context).textTheme.bodyLarge),
                            IconButton(
                              icon: const Icon(
                                Icons.public,
                                color: Colors.blue,
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
                                icon: const Icon(
                                  Icons.login,
                                  color: Colors.blue,
                                  size: 30,
                                ),
                                onPressed: () {
                                  getGoogle.signOut();
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
              Row(
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
              )
            ]),
      ),
    );
  }
}
