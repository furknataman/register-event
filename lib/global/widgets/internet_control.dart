import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr/services/service.dart';

Widget internetControl(BuildContext context, WidgetRef ref) {
  return Expanded(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'An error occurred. Can you try again?',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        IconButton(
            onPressed: () async {
              ref.invalidate(userDataProvider);
              ref.invalidate(presentationDataProvider);
            },
            icon: const Icon(Icons.restart_alt))
      ],
    ),
  );
}
