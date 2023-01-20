// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:lucide_icons/lucide_icons.dart';

class NotificationPage extends ConsumerWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
        label: const Text(
          "Clear All",
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
        ),
        onPressed: () {},
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
        leading: IconButton(
          icon: Icon(
            LucideIcons.arrowLeftCircle,
            size: 30,
            color: Theme.of(context).secondaryHeaderColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Notifications",
          style: Theme.of(context).textTheme.displayLarge,
          textAlign: TextAlign.left,
        ),
      ),
      body: Column(children: [
        Center(
          child: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
            width: MediaQuery.of(context).size.width - 40,
            height: 60,
            child: Row(
              children: [
                const CircleAvatar(
                  child: Icon(
                    HeroiconsMini.fire,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "An event has started!",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Modern math event has started in Hall",
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        )
      ]),
    );
  }
}
