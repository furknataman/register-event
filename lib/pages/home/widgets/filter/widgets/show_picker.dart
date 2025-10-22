import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:autumn_conference/pages/home/widgets/filter/filter_provider.dart';

class Picker extends ConsumerWidget {
  const Picker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterProvider = ref.watch<FilterPage>(alertPageConfig);
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => filterProvider.showDialog(
        context,
        CupertinoPicker(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          magnification: 1.22,
          squeeze: 1.2,
          useMagnifier: true,
          itemExtent: 32,
          onSelectedItemChanged: (int selectedItem) {
            filterProvider.changeListShow(selectedItem);
          },
          children: List<Widget>.generate(filterProvider.showList.length, (int index) {
            return Center(
              child: Text(
                filterProvider.showList[index],
                style: const TextStyle(fontSize: 16),
              ),
            );
          }),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 4),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Theme.of(context).secondaryHeaderColor,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(14),
          ),
        ),
        child: Row(
          children: [
            Text(filterProvider.showList[filterProvider.selectedList],
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(
              width: 6,
            ),
            Icon(
              LucideIcons.chevronsUpDown,
              color: Theme.of(context).secondaryHeaderColor,
            )
          ],
        ),
      ),
    );
  }
}
