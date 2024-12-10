import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationHelper {
  static void pushAndRemoveUntil(BuildContext context, String routeName,
      {Object? extra}) {
    context.go(routeName, extra: extra);
  }

  static void goBack(BuildContext context) {
    context.pop();
  }
}
