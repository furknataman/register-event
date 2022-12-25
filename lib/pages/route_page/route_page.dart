import 'package:flutter/material.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:qr/global/svg.dart';
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
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color.fromRGBO(255, 255, 255, 1),
              Color.fromRGBO(255, 255, 255, 0),
            ],
          )),
          height: 106,
          width: MediaQuery.of(context).size.width,
          child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16, top: 30),
              child: Container(
                  height: 60,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.25),
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
                        showSelectedLabels: false,
                        showUnselectedLabels: false,
                        currentIndex: _currentIndex,
                        unselectedItemColor: const Color(0xff485FFF),
                        selectedItemColor: const Color(0xff485FFF),
                        selectedIconTheme: const IconThemeData(color: Color(0xff485FFF)),
                        iconSize: 30,
                        items: <BottomNavigationBarItem>[
                          BottomNavigationBarItem(
                            activeIcon: homeIconBold,
                            label: " ",
                            icon: homeIcon,
                          ),
                          const BottomNavigationBarItem(
                            activeIcon: Icon(HeroiconsMini.qrCode),
                            label: " ",
                            icon: Icon(HeroiconsOutline.qrCode),
                          ),
                          const BottomNavigationBarItem(
                            activeIcon: Icon(HeroiconsSolid.cog6Tooth),
                            label: " ",
                            icon: Icon(HeroiconsOutline.cog6Tooth),
                          )
                        ]),
                  ))),
        ));
  }
}
