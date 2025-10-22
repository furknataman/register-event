import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autumn_conference/services/service.dart';
import 'package:autumn_conference/l10n/app_localizations.dart';

Widget internetControl(BuildContext context, WidgetRef ref) {
  return Expanded(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.connectionError,
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
