// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';

import '../../global/svg.dart';

class Settingspage extends StatefulWidget {
  const Settingspage({super.key});

  @override
  State<Settingspage> createState() => _SettingspageState();
}

class _SettingspageState extends State<Settingspage> {
  @override
  Widget build(BuildContext context) {
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
                    Text("Stephan Curl", style: Theme.of(context).textTheme.titleLarge),
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
                        Icon(
                          Icons.login,
                          size: 30,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ]),
      ),
    );
  }
}
