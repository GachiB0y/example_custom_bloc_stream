import 'dart:async';

import 'package:bloc_stream/bloc_stream.dart';
import 'package:bloc_stream/common/model/dependencies.dart';
import 'package:bloc_stream/feature/initialization/data/platform/platform_initialization.dart';
import 'package:flutter/material.dart';

/// Initializes the app and returns a [Dependencies] object
Future<Dependencies> $initializeDependencies({
  void Function(int progress, String message)? onProgress,
}) async {
  final dependencies = Dependencies();

  final totalSteps = _initializationSteps.length;
  var currentStep = 0;
  for (final step in _initializationSteps.entries) {
    try {
      currentStep++;

      /// need from show progress % in spash screen and message
      /// step.key - message
      final percent = (currentStep * 100 ~/ totalSteps).clamp(0, 100);

      onProgress?.call(percent, step.key);

      /// This we instead of print() write logger
      debugPrint(
          'Initialization | $currentStep/$totalSteps ($percent%) | "${step.key}"');

      //In each step we pass our DI Container
      await step.value(dependencies);
    } on Object catch (error, stackTrace) {
      /// This we instead of print() write logger
      debugPrint(
        'Initialization failed at step "${step.key}": $error\nStackTrace: $stackTrace',
      );
      Error.throwWithStackTrace(
          'Initialization failed at step "${step.key}": $error', stackTrace);
    }
  }
  return dependencies;
}

typedef _InitializationStep = FutureOr<void> Function(
    Dependencies dependencies);
final Map<String, _InitializationStep> _initializationSteps =
    <String, _InitializationStep>{
  'Platform pre-initialization': (_) => $platformInitialization(),
  'Creating app metadata': (_) {},
  'Observer state managment': (_) {},
  'Initializing analytics': (_) {},
  'Log app open': (_) {},
  'Get remote config': (_) {},
  'Restore settings': (_) {},
  // 'Initialize shared preferences': (dependencies) async =>
  //     dependencies.sharedPreferences = await SharedPreferences.getInstance(),
  // 'Prepare authentication controller': (dependencies) =>
  //     dependencies.authenticationController = AuthenticationController(
  //       repository: AuthenticationRepositoryImpl(
  //         sharedPreferences: dependencies.sharedPreferences,
  //       ),
  //     ),
  // 'Restore last user': (dependencies) =>
  //     dependencies.authenticationController.restore(),
  // 'Rest Client': (dependencies) {
  //   dependencies.restClient = RestClient(
  //     baseUrl: 'https://example.com',
  //   );
  // },
  // 'Color Api client': (dependencies) async {
  //   dependencies.colorApiClient =
  //       await ColorApiClient(httpClient: dependencies.restClient);
  // },
  // 'Colors Repository': (dependencies) {
  //   dependencies.colorsRepository = ColorsRepositoryImpl(
  //     apiClient: dependencies.colorApiClient,
  //   );
  // },
  'Color box BLoC': (dependencies) {
    // final colorBoxBLoC = ColorBoxBloc(
    //   repository: dependencies.colorsRepository,
    // )..fetch();
    // dependencies.colorBoxBloc = colorBoxBLoC;

    final bloc = ColorBoxBloc();
    dependencies.colorBoxBloc = bloc;
  },
  'Initialize localization': (_) {},
  'Migrate app from previous version': (_) {},
  'Collect logs': (_) {},
  'Log app initialized': (_) {},
};
