import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:autumn_conference/pages/home/home_page.dart';
import 'package:autumn_conference/pages/maps/maps.dart';
import 'package:autumn_conference/pages/scan/scan.dart';
import 'package:autumn_conference/pages/settings/settings_page.dart';
import 'package:autumn_conference/theme/theme_extends.dart';


class RoutePage extends ConsumerStatefulWidget {
  const RoutePage({super.key});

  @override
  ConsumerState<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends ConsumerState<RoutePage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
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
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            controller: _pageController,
            children: const <Widget>[
              Homepage(),
              ScannerPage(),
              MapsPage(),
              SettingsPage()
            ]),
        bottomNavigationBar: SizedBox(
          height: 95,
          child: BottomNavigationBar(
              onTap: (index) {
                setState(() => _currentIndex = index);
                _pageController.jumpToPage(index);
              },
              backgroundColor: Theme.of(context).colorScheme.mainColor,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
              currentIndex: _currentIndex,
              unselectedItemColor: Colors.white,
              selectedItemColor: Theme.of(context).colorScheme.appColor,
              selectedIconTheme: const IconThemeData(color: Color(0xff232f60)),
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
                  activeIcon: Icon(HeroiconsSolid.map),
                  label: " ",
                  icon: Icon(HeroiconsOutline.map),
                ),
                BottomNavigationBarItem(
                  activeIcon: Icon(HeroiconsSolid.cog6Tooth),
                  label: " ",
                  icon: Icon(HeroiconsOutline.cog6Tooth),
                ),
              ]),
        ));
  }
}
