import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';


void showAppSnackbar(String message) {
  final context = StackedService.navigatorKey?.currentContext;
  if (context == null) return;

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
}