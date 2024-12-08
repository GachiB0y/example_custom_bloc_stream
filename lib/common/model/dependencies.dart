import 'package:bloc_stream/feature/color/bloc/color_bloc.dart';
import 'package:bloc_stream/feature/counter/stream_bloc_command/bloc/counter_stream_bloc.dart';
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

  /// Counter Command
  late final DIConaierCommand diConaierCommand;
  late final FactoryCommand factoryCommand;
}

abstract class DIConaierCommand {
  const DIConaierCommand({
    required this.incrementCommand,
    required this.decrementCommand,
    required this.initStateCommand,
    required this.commandHistory,
  });

  final CommandHistory commandHistory;
  final IncrementCommand incrementCommand;
  final DecrementCommand decrementCommand;
  final InitStateCommand initStateCommand;
}

class DICommand extends DIConaierCommand {
  const DICommand({
    required super.incrementCommand,
    required super.decrementCommand,
    required super.initStateCommand,
    required super.commandHistory,
  });
}
