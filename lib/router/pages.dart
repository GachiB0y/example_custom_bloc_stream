// Pages and screens, just for the example
import 'package:bloc_stream/main.dart';
import 'package:flutter/material.dart';

enum AppPages {
  home('home', title: 'Home'),
  settings('settings', title: 'Settings'),
  bloc('bloc-example', title: 'Bloc Example');

  const AppPages(this.name, {this.title});

  final String name;

  final String? title;

  Page<Object?> get page => MaterialPage<Object?>(
        key: ValueKey<AppPages>(this),
        child: Builder(builder: (context) {
          return builder(context);
        }),
      );

  Widget builder(BuildContext context) => switch (this) {
        AppPages.home => const HomePage(),
        AppPages.settings => const SettingPage(),
        AppPages.bloc => const MyHomePage(),
      };
}
