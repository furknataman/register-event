import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr/global/global_veriable/events_info.dart';
import 'package:qr/global/global_veriable/user_info.dart';
import '../../authentication/login_serice.dart';
import '../../global/svg.dart';
import '../../notifiation/local_notification/notification.dart';
class Settingspage extends ConsumerStatefulWidget {
  const Settingspage({super.key});

  @override
  ConsumerState<Settingspage> createState() => _SettingspageState();
}

class _SettingspageState extends ConsumerState<Settingspage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final getGoogle = ref.watch<GoogleProvder>(googleConfig);
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(userInfo.user!.name.toString(),
                        style: Theme.of(context).textTheme.titleLarge),
                    Text("Berlin Technical University",
                        style: Theme.of(context).textTheme.displaySmall),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Enable Notifications",
                            style: Theme.of(context).textTheme.bodyLarge),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Visit TOK Website",
                            style: Theme.of(context).textTheme.bodyLarge),
                       const Icon(
                          Icons.web,
                          size: 30,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Logout", style: Theme.of(context).textTheme.bodyLarge),
                        IconButton(
                          icon: const Icon(
                            Icons.login,
                            size: 30,
                          ),
                          onPressed: () {
                            getGoogle.signOut();
                          },
                        )
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
                    onPressed: () {
                
                      
                      LocalNoticeService().addNotification(
                        'testing',
                        'Test Titile',
                        'Test Body',
                        DateTime.now().millisecondsSinceEpoch + 4000,
                      );

                      /*eventsInfo.readEvents();
                      eventsInfo.writeEvents(
                        duration: 40,
                          name: "Matematik3",
                          description: "Burada Açıklama yazıyor3",
                          imageUrl:
                              "https://images.unsplash.com/photo-1624555130581-1d9cca783bc0?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2942&q=80",
                          active: true,
                          eventLocationlUrl: "https://iili.io/HoF2Gz7.png",
                          eventsLocation: "hall b",
                          id: 2,
                          capacity: 20,
                          speakers: ["Berat2", "Tamer2"],
                          attendedEvents: [1231, 231],
                          timestamp: Timestamp.now());*/
                    },
                  )
                ],
              )
            ]),
      ),
    );
  }
}
