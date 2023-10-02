import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr/global/svg.dart';
import 'package:qr/pages/start/widgets/startlogo.dart';
import 'package:qr/pages/start/widgets/text_field.dart';
import '../../authentication/login_service.dart';

class StartPage extends ConsumerWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final getGoogle = ref.watch<GoogleProvider>(googleConfig);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 72, 72),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromARGB(255, 255, 72, 72),
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
                    margin: const EdgeInsets.only(left: 70, right: 70),
                    height: 250,
                    child: LoginForm(getGoogle: getGoogle),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
