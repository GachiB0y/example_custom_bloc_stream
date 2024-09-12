import 'dart:async';
import 'dart:math';

import 'package:bloc_stream/app.dart';
import 'package:bloc_stream/common/widget/app_error.dart';
import 'package:bloc_stream/feature/initialization/data/initialization.dart';
import 'package:bloc_stream/feature/initialization/widget/inherited_dependencies.dart';
import 'package:flutter/material.dart';

void main() {
  runZonedGuarded<void>(
    () async {
      /// create initProgress
      /// where progreess this % of initialization
      /// and message this now initializing
      final initializationProgress =
          ValueNotifier<({int progress, String message})>(
              (progress: 0, message: ''));

      /// this show custom splash screen6 where show progress initialization
      /* runApp(SplashScreen(progress: initializationProgress)); */

      /// initializeApp with onProgress and onSuccess and onError
      /// where onProgress we set progress step and message
      /// and onSuccess we set dependencies
      /// onSuccess contains inherited Widget where we get dependencies from context
      $initializeApp(
        onProgress: (progress, message) => initializationProgress.value =
            (progress: progress, message: message),
        onSuccess: (dependencies) => runApp(
          InheritedDependencies(
            dependencies: dependencies,
            child: App(controller: ValueNotifier<List<Page<Object?>>>([])),
          ),
        ),
        onError: (error, stackTrace) {
          runApp(AppError(error: error));

          /// This we instead of print() write logger
          (error, stackTrace) =>
              print('Error with initialization: $error\n$stackTrace');
        },
      ).ignore();
    },

    /// This we instead of print() write logger
    // ignore: avoid_print
    (error, stackTrace) => print('Top level exception: $error\n$stackTrace'),
  );
}
