import 'package:bloc_stream/router/pages.dart';
import 'package:bloc_stream/router/router.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({required this.controller, super.key});

  final ValueNotifier<List<Page<Object?>>> controller;

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Declarative Navigator Example',
        theme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        builder: (context, _) => AppNavigator(
          home: AppPages.home.page(),
          controller: controller,
        ),
      );
}

/// {@template main}
/// HomeScreen widget.
/// {@endtemplate}
class HomeScreen extends StatelessWidget {
  /// {@macro main}
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          actions: <Widget>[
            // Show modal dialog
            IconButton(
              icon: const Icon(Icons.warning),
              tooltip: 'Show modal dialog',
              onPressed: () => showDialog<void>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Warning'),
                  content: const Text('This is a warning message.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ),
            ),
            // Go to settings page
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Drop routes and go to settings',
              onPressed: () => AppNavigator.change(
                context,
                (pages) => [
                  AppPages.home.page(),
                  AppPages.settings.page(),
                ],
              ),
            ),
          ],
        ),
        body: Center(
          child: Column(
            children: [
              const Text('Home'),
              ListTile(
                title: const Text('Go Bloc Exmaple'),
                onTap: () => AppNavigator.change(
                    context,
                    (pages) => [
                          ...pages,
                          AppPages.bloc.page(),
                        ]),
              ),
              const Text('Catalog'),
              ListTile(
                title: const Text('Go  to Catalog'),
                onTap: () => AppNavigator.change(
                    context,
                    (pages) => [
                          ...pages,
                          AppPages.catalog.page(),
                        ]),
              ),
            ],
          ),
        ),
      );
}

/// {@template main}
/// SettingScreen widget.
/// {@endtemplate}
class SettingScreen extends StatelessWidget {
  /// {@macro main}
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: const Center(
          child: Text('Settings'),
        ),
      );
}
