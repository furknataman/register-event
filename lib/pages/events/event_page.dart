import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr/db/db_model/db_model_events.dart';
import 'package:qr/global/date_time_converter.dart';
import 'package:qr/global/global_veriable/user_info.dart';
import 'package:qr/pages/events/widgets/register_button.dart';
import 'widgets/location_widget.dart';

class Eventspage extends ConsumerStatefulWidget {
  final ClassModelEvents? event;
  const Eventspage(this.event, {Key? key}) : super(key: key);

  @override
  ConsumerState<Eventspage> createState() => _Eventspage(event: event);
}

class _Eventspage extends ConsumerState<Eventspage> {
  ClassModelEvents? event;
  _Eventspage({@required this.event});
  String? timeData;
  ScrollController scrollController = ScrollController();
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      setState(() {
        _isVisible = scrollController.offset > 130;
      });
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final userInfo = ref.watch<UserInfo>(userInfoConfig);

    ClassTime time = classConverter(event!.dateTime!, event!.duration!);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: CustomScrollView(
        controller: scrollController,
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.black.withOpacity(0.88),
            pinned: true,
            snap: false,
            floating: false,
            expandedHeight: 220.0,
            flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                title: Visibility(
                  visible: _isVisible,
                  child: Text(
                    event!.name.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                ),
                background: Container(
                  color: Theme.of(context).backgroundColor,
                  child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      child: Image.network(event!.imageUrl!, fit: BoxFit.cover)),
                )),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 17, right: 17),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        event!.name.toString(),
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      RegisterButton(
                        userInfo: userInfo,
                        event: event,
                      ),
                    ],
                  ),
                  textContainer(
                      "Date of Event", Theme.of(context).textTheme.displayMedium),
                  textContainer(
                      "${time.month.toString()} ${time.day.toString()}th ${time.clock.toString()}   ",
                      Theme.of(context).textTheme.titleSmall,
                      bottomPadding: 10),
                  textContainer("Speakers", Theme.of(context).textTheme.displayMedium),
                  SizedBox(
                    height: 25,
                    child: ListView.separated(
                      separatorBuilder: (BuildContext context, int index) => Padding(
                        padding: const EdgeInsets.only(left: 6, right: 6),
                        child: Container(
                          alignment: Alignment.center,
                          width: 2,
                          height: 2,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).secondaryHeaderColor),
                        ),
                      ),
                      reverse: false,
                      shrinkWrap: false,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        context;
                        return textContainer(event!.speakers![index].toString(),
                            Theme.of(context).textTheme.titleSmall,
                            bottomPadding: 0);
                      },
                      itemCount: event!.speakers!.length,
                    ),
                  ),
                  textContainer("Cpacity", Theme.of(context).textTheme.displayMedium),
                  textContainer(
                      "${event!.capacity! - event!.participantsNumber!} free seats left from ${event!.capacity}",
                      Theme.of(context).textTheme.titleSmall,
                      bottomPadding: 10),
                  textContainer("Description", Theme.of(context).textTheme.displayMedium),
                  textContainer(event!.description!.toString(),
                      Theme.of(context).textTheme.titleSmall,
                      bottomPadding: 10),
                  textContainer("Where is ${event!.eventsLocation}?",
                      Theme.of(context).textTheme.displayMedium,
                      bottomPadding: 10),
                  LocationWidget(event: event),
                ],
              ),
            ),
          ])),
        ],
      ),
    );
  }

  Container textContainer(String? text, TextStyle? textStyle, {double bottomPadding = 5}) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Text(
        text!,
        style: textStyle,
      ),
    );
  }
}
