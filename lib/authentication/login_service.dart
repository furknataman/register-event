import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final googleConfig = ChangeNotifierProvider((ref) => GoogleProvider());

class GoogleProvider extends ChangeNotifier {
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();
}
