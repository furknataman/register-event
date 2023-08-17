import 'package:flutter/material.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:qr/pages/home/home_page.dart';
import 'package:qr/pages/scan/scan.dart';
import 'package:qr/pages/settings/settings_page.dart';
import 'package:qr/theme/theme_extends.dart';

import '../../notifiation/push_notification/push_notification.dart';

class RoutePage extends StatefulWidget {
  const RoutePage({super.key});

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    setFiraBase();
  }

  int _currentIndex = 0;
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            controller: _pageController,
            children: const <Widget>[Homepage(), ScannerPage(), Settingspage()]),
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          child: BottomNavigationBar(
              onTap: (index) {
                setState(() => _currentIndex = index);
                _pageController.jumpToPage(index);
              },
              backgroundColor: Theme.of(context).colorScheme.mainColor,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              currentIndex: _currentIndex,
              unselectedItemColor: Colors.white,
              selectedItemColor: const Color(0xffe43c2f),
              selectedIconTheme: const IconThemeData(color: Color(0xffe43c2f)),
              iconSize: 31,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  activeIcon: Icon(HeroiconsMini.home),
                  label: " ",
                  icon: Icon(HeroiconsOutline.home),
                ),
                BottomNavigationBarItem(
                  activeIcon: Icon(HeroiconsMini.qrCode),
                  label: " ",
                  icon: Icon(HeroiconsOutline.qrCode),
                ),
                BottomNavigationBarItem(
                  activeIcon: Icon(HeroiconsSolid.cog6Tooth),
                  label: " ",
                  icon: Icon(HeroiconsOutline.cog6Tooth),
                )
              ]),
        ));
  }
}
