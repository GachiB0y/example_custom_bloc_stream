import 'dart:async';

import 'package:bloc_stream/bloc_stream.dart';
import 'package:bloc_stream/router/pages.dart';
import 'package:bloc_stream/router/router.dart';
import 'package:flutter/material.dart';

void main() => runZonedGuarded<void>(
      () => runApp(App(controller: ValueNotifier<List<Page<Object?>>>([]))),
      // ignore: avoid_print
      (error, stackTrace) => print('Top level exception: error\nstackTrace'),
    );

class App extends StatelessWidget {
  const App({required this.controller, super.key});

  final ValueNotifier<List<Page<Object?>>> controller;

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Declarative Navigator Example',
        theme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        builder: (context, _) => AppNavigator(
          home: AppPages.home.page,
          controller: controller,
        ),
      );
}

/// {@template main}
/// HomePage widget.
/// {@endtemplate}
class HomePage extends StatelessWidget {
  /// {@macro main}
  const HomePage({super.key});

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
                  AppPages.home.page,
                  AppPages.settings.page,
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
                          AppPages.bloc.page,
                        ]),
              ),
            ],
          ),
        ),
      );
}

/// {@template main}
/// MyHomePage widget.
/// {@endtemplate}
class MyHomePage extends StatefulWidget {
  /// {@macro main}
  const MyHomePage({super.key});

  /// The state from the closest instance of this class
  /// that encloses the given context, if any.
  static _MyHomePageState? maybeOf(BuildContext context) =>
      context.findAncestorStateOfType<_MyHomePageState>();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

/// State for widget MyHomePage.
class _MyHomePageState extends State<MyHomePage> {
  /* #region Lifecycle */
  final ColorBoxBloc _colorBloc = ColorBoxBloc();
  @override
  void initState() {
    super.initState();
    // Initial state initialization
  }

  @override
  void didUpdateWidget(MyHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Widget configuration changed
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // The configuration of InheritedWidgets has changed
    // Also called after initState but before build
  }

  @override
  void dispose() {
    // Permanent removal of a tree stent
    _colorBloc.close();
    super.dispose();
  }
  /* #endregion */

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Bloc with stream'),
        ),
        body: Center(
          child: StreamBuilder<ColorBoxState>(
            stream: _colorBloc.stream,
            // initialData: Colors.red,
            builder: (context, snapshot) {
              if (snapshot.data is ColorBoxLoading) {
                return const CircularProgressIndicator();
              } else if (snapshot.data is ColorBoxLoaded) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: 100,
                  height: 100,
                  color: (snapshot.data as ColorBoxLoaded).color,
                );
              } else {
                return const Text('Error');
              }
            },
          ),
        ),
        floatingActionButton:
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
            heroTag: 'red',
            backgroundColor: Colors.red,
            onPressed: () {
              _colorBloc.add(ChangeRedColorEvent());
            },
          ),
          FloatingActionButton(
            heroTag: 'green',
            backgroundColor: Colors.green,
            onPressed: () {
              _colorBloc.add(ChangeGreenColorEvent());
            },
          ),
        ]),
      );
}

/// {@template main}
/// SettingPage widget.
/// {@endtemplate}
class SettingPage extends StatelessWidget {
  /// {@macro main}
  const SettingPage({super.key});

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
