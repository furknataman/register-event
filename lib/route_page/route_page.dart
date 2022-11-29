import 'package:flutter/material.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:qr/pages/home/home_page.dart';
import 'package:qr/pages/scan/scan.dart';

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
          children: const <Widget>[Homepage(), ScannerPage(), ScannerPage()]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16),
        child: Container(
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
                iconSize: 35,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    activeIcon: Icon(HeroiconsSolid.home),
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
          ),
        ),
      ),
    );
  }
}
