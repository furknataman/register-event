import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr/pages/home/widgets/filter/filter_provider.dart';
import 'package:qr/theme/theme_extends.dart';

class FilterBottombar extends ConsumerWidget {
  const FilterBottombar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterProvider = ref.watch<FilterPage>(alertPageConfig);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.disable,
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          ),
          onPressed: () {
            filterProvider.reset();
          },
          child: Text("Reset ", style: Theme.of(context).textTheme.labelLarge),
        ),
        const SizedBox(
          width: 20,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          ),
          onPressed: () {},
          child: const Text(
            "Ok",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        )
      ],
    );
  }
}
