import 'package:flutter/material.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:qr/pages/home/home_page.dart';
import 'package:qr/pages/scan/scan.dart';
import 'package:qr/pages/settings/settings_page.dart';

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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
            width: MediaQuery.of(context).size.width - 70,
            height: 61,
            decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.8),
                      blurRadius: 14,
                      offset: Offset(0, 4))
                ]),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              child: BottomNavigationBar(
                  onTap: (index) {
                    setState(() => _currentIndex = index);
                    _pageController.jumpToPage(index);
                  },
                  backgroundColor: const Color(0xff232f60),
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
            )));
  }
}
