import 'package:bloc_stream/feature/deeplinks/bloc/deeplink_bloc.dart';
import 'package:bloc_stream/router/pages.dart';
import 'package:bloc_stream/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class App extends StatelessWidget {
  const App({required this.controller, super.key});

  final ValueNotifier<List<Page<Object?>>> controller;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Declarative Navigator Example',
      theme: ThemeData.light(),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale('en', ''),
        Locale('zh', ''),
        Locale('he', ''),
        Locale('es', ''),
        Locale('ru', ''),
        Locale('ko', ''),
        Locale('hi', ''),
      ],
      debugShowCheckedModeBanner: false,
      builder: (context, _) => ConfigRoute(controller: controller),
    );
  }
}

class ConfigRoute extends StatefulWidget {
  const ConfigRoute({
    super.key,
    required this.controller,
  });

  final ValueNotifier<List<Page<Object?>>> controller;

  @override
  State<ConfigRoute> createState() => _ConfigRouteState();
}

class _ConfigRouteState extends State<ConfigRoute> {
  late final DeeplinkBloc bloc;
  @override
  void initState() {
    bloc = DeeplinkBloc();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Page<Object?>>>(
        stream: bloc.streamOutPut,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return AppNavigator(
              home: AppPages.home.page(),
              controller: widget.controller,
            );
          } else {
            return AppNavigator(
              home: AppPages.home.page(),
              controller: ValueNotifier<List<Page<Object?>>>([
                ...widget.controller.value,
                ...snapshot.data ?? [],
              ]),
            );
          }
        });
  }
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
      body: const BodyWidget());
}

class BodyWidget extends StatelessWidget {
  const BodyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text('Bloc Exmaple'),
          ListTile(
            title: const Text('Go Bloc Exmaple'),
            onTap: () => AppNavigator.change(
                context,
                (pages) => [
                      ...pages,
                      AppPages.bloc.page(),
                    ]),
          ),
          const Text('Counter Notifier'),
          ListTile(
            title: const Text('Go  Counter Notifier'),
            onTap: () => AppNavigator.change(
                context,
                (pages) => [
                      ...pages,
                      AppPages.counterNotifier.page(),
                    ]),
          ),
          const Text('Counter Stream package StreamBloc'),
          ListTile(
            title:
                const Text('Go Counter Stream  with used package StreamBloc'),
            onTap: () => AppNavigator.change(
                context,
                (pages) => [
                      ...pages,
                      AppPages.blocStreamCounter.page(),
                    ]),
          ),
          const Text('Counter Custom Stream Bloc '),
          ListTile(
            title: const Text('Go Counter Stream Bloc'),
            onTap: () => AppNavigator.change(
                context,
                (pages) => [
                      ...pages,
                      AppPages.blocCustomStreamCounter.page(),
                    ]),
          ),
          const Text('Counter Bloc '),
          ListTile(
            title: const Text('Go Counter Bloc'),
            onTap: () => AppNavigator.change(
                context,
                (pages) => [
                      ...pages,
                      AppPages.blocCounter.page(),
                    ]),
          ),
          const Text('Counter Cubit '),
          ListTile(
            title: const Text('Go Counter Cubit'),
            onTap: () => AppNavigator.change(
                context,
                (pages) => [
                      ...pages,
                      AppPages.cubitCounter.page(),
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
    );
  }
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
