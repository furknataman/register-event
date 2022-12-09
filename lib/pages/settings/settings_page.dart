// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr/global/global_veriable/events_info.dart';
import 'package:qr/global/global_veriable/user_info.dart';
import '../../authentication/login_serice.dart';
import '../../global/svg.dart';

class Settingspage extends ConsumerStatefulWidget {
  const Settingspage({super.key});

  @override
  ConsumerState<Settingspage> createState() => _SettingspageState();
}

class _SettingspageState extends ConsumerState<Settingspage> {
  @override
  Widget build(BuildContext context) {
    final getGoogle = ref.watch<GoogleProvder>(googleConfig);
    final userInfo = ref.read<UserInfo>(userInfoConfig);
    final eventsInfo = ref.read<EventsInfo>(eventsInfoConfig);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 30, right: 30),
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
                        Icon(
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
                          icon: Icon(
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
                    icon: Icon(
                      Icons.login,
                      size: 30,
                    ),
                    onPressed: () {
                      eventsInfo.readEvents2();
                      /*eventsInfo.writeEvents(
                          name: "furkan123",
                          description: "description",
                          imageUrl: "imageUrl",
                          active: false,
                          id: 2,
                          capacity: 12,
                          speakers: ["123", "12"],
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
