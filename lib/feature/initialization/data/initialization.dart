import 'dart:async';

/* import 'package:database/database.dart'; */
import 'package:bloc_stream/common/model/dependencies.dart';
import 'package:bloc_stream/feature/initialization/data/initialize_dependencies.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Ephemerally initializes the app and prepares it for use.
Future<Dependencies>? _$initializeApp;

/// Initializes the app and prepares it for use.
Future<Dependencies> $initializeApp({
  void Function(int progress, String message)? onProgress,
  FutureOr<void> Function(Dependencies dependencies)? onSuccess,
  void Function(Object error, StackTrace stackTrace)? onError,
}) =>
    _$initializeApp ??= Future<Dependencies>(() async {
      /// create widget binding
      late final WidgetsBinding binding;

      try {
        /// create widget binding, with bindigs Flutter withs Flutter Engine
        binding = WidgetsFlutterBinding.ensureInitialized()..deferFirstFrame();

        /// set orientation only portrait
        /* await SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]); */
        await _catchExceptions();
        final dependencies =
            await $initializeDependencies(onProgress: onProgress)
                .timeout(const Duration(minutes: 7));
        await onSuccess?.call(dependencies);
        return dependencies;
      } on Object catch (error, stackTrace) {
        onError?.call(error, stackTrace);
        debugPrint('Failed to initialize app: $error\n$stackTrace');

        rethrow;
      } finally {
        binding.addPostFrameCallback((_) {
          // Closes splash screen, and show the app layout.
          binding.allowFirstFrame();
          //final context = binding.renderViewElement;
        });
        _$initializeApp = null;
      }
    });

/// Resets the app's state to its initial state.
@visibleForTesting
Future<void> $resetApp(Dependencies dependencies) async {}

/// Disposes the app and releases all resources.
@visibleForTesting
Future<void> $disposeApp(Dependencies dependencies) async {}

Future<void> _catchExceptions() async {
  try {
    PlatformDispatcher.instance.onError = (error, stackTrace) {
      /// This we instead of print() write logger
      debugPrint('ROOT ERROR\r\n: $error\n$stackTrace');

      return true;
    };

    final sourceFlutterError = FlutterError.onError;

    /// Interceptor on FlutterError
    FlutterError.onError = (final details) {
      /// This we instead of print() write logger
      debugPrint(
          'FLUTTER ERROR\r\n: ${details.exception}\n${details.stack ?? StackTrace.current}');

      // FlutterError.presentError(details);
      sourceFlutterError?.call(details);
    };
  } on Object catch (error, stackTrace) {
    /// This we instead of print() write logger
    debugPrint('ERROR\r\n: $error\n$stackTrace');
  }
}
