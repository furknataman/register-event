import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr/global/svg.dart';
import 'package:qr/pages/start/widgets/startlogo.dart';
import 'package:qr/pages/start/widgets/text_field.dart';
import '../../authentication/login_serice.dart';

class StartPage extends ConsumerWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final getGoogle = ref.watch<GoogleProvder>(googleConfig);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xff485FFF),
            Color(0xff0D175F),
          ],
        )),
        child: Stack(children: [
          Positioned(
            bottom: 0,
            right: 0,
            child: elipse(MediaQuery.of(context).size.width),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const StartPageWidgets(),
                Container(
                  margin: const EdgeInsets.only(left: 90, right: 90),
                  height: 250,
                  child: LoginForm(getGoogle: getGoogle),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
