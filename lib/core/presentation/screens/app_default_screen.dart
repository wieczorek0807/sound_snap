import 'package:flutter/material.dart';

import '../values/values.dart';

class AppDefaultScreen extends StatelessWidget {
  const AppDefaultScreen({required this.title, required this.body, super.key, this.floatingActionButton});
  final Widget body;
  final Widget? floatingActionButton;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(title),
        ),
        body: Padding(
          padding: AppPadding.defaultScreenPadding,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                  maxWidth: AppDimensions.boxConstraintsMaxWidth, minWidth: AppDimensions.boxConstraintsMinWidth),
              child: body,
            ),
          ),
        ),
        floatingActionButton: floatingActionButton);
  }
}
