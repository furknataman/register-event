import 'package:flutter/material.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 34, top: 30),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
              CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage('https://picsum.photos/250?image=9')),
              Icon(
                HeroiconsOutline.bell,
                color: Color(0xff333333),
                size: 45,
              )
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 19, top: 34, bottom: 15),
            child: Row(
              children: [
                Text(
                  "Upcoming Events",
                  style: Theme.of(context).textTheme.displayLarge,
                )
              ],
            ),
          ),
          actionStac(),
        ]),
      ),
    );
  }

  Padding actionStac() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            decoration:
                const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(13))),
            width: MediaQuery.of(context).size.width - 40,
            height: 237,
          ),
          Positioned(
            top: 0,
            child: Container(
              width: MediaQuery.of(context).size.width - 40,
              height: 166,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        "assets/images/Rectangle2.png",
                      ),
                      fit: BoxFit.fill),
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15), topRight: Radius.circular(15))),
            ),
          ),
          Positioned(
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.only(top: 10, left: 13, right: 13, bottom: 13),
                decoration: const BoxDecoration(
                    color: Color(0xffFFFFFF),
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10))),
                height: 71,
                width: 356,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Modern Math",
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          Text(
                            "13:40 - 14:00",
                            style: Theme.of(context).textTheme.displayMedium,
                          )
                        ],
                      ),
                      Text(
                        "Hall E",
                        style: Theme.of(context).textTheme.displaySmall,
                      )
                    ]),
              )),
          Positioned(
              top: 13,
              left: 13,
              child: Container(
                decoration: const BoxDecoration(
                    color: Color(0xffFFFFFF),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                height: 38,
                width: 38,
                child: Column(
                  children: [
                    Text("14", style: Theme.of(context).textTheme.labelLarge),
                    Text("Ara", style: Theme.of(context).textTheme.labelSmall)
                  ],
                ),
              )),
          Positioned(
              top: 13,
              right: 13,
              child: Container(
                decoration: const BoxDecoration(
                    color: Color(0xffFFFFFF),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                height: 26,
                width: 72,
              )),
        ],
      ),
    );
  }
}
