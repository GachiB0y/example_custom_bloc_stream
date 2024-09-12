import 'package:bloc_stream/bloc_stream.dart';
import 'package:bloc_stream/feature/initialization/widget/inherited_dependencies.dart';
import 'package:flutter/material.dart';

/// Dependencies
class Dependencies {
  Dependencies();

  /// The state from the closest instance of this class.
  factory Dependencies.of(BuildContext context) =>
      InheritedDependencies.of(context);

  // /// Rest client
  // late final RestClient restClient;

  // /// Color Api client
  // late final IColorApiClient colorApiClient;

  // /// Repository ColorBox
  // late final IColorBoxRepository colorBoxRepository;

  /// ColorBoxBloc
  late final ColorBoxBloc colorBoxBloc;
}
