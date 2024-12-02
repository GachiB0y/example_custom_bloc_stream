import 'dart:async';

import 'package:bloc_stream/feature/counter/data/repo/counter_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:stream_bloc/stream_bloc.dart';

part 'counter_stream_event.dart';
part 'counter_stream_state.dart';

/// Business Logic Component CounterStreamBLoC
class CounterStreamBLoC extends StreamBloc<CounterEvent, CounterStreamState>
    implements EventSink<CounterEvent> {
  CounterStreamBLoC({
    required ICounterRepository repository,
    final CounterStreamState? initialState,
  })  : _repository = repository,
        super(
          initialState ??
              const CounterStreamState.idle(
                data: 0,
                message: 'Initial idle state',
              ),
        ) {
    _receiver = CounterControllerReceiver(
      repository: _repository,
      state: state,
    );
  }

  final ICounterRepository _repository;

  final CounterControllerInvoker _invoker = CounterControllerInvoker();
  late final CounterControllerReceiver _receiver;

  @override
  Stream<CounterStreamState> mapEventToStates(CounterEvent event) async* {
    switch (event) {
      case IncrementCounterEvent incrementCounterEvent:
        yield* _invoker.executeCommand(IncrementCommand(
            receiver: _receiver, event: incrementCounterEvent));
      case DecrementCounterEvent decrementCounterEvent:
        yield* decrement(decrementCounterEvent);
      case InitStateCounterEvent initStateCounterEvent:
        yield state;
    }
  }

  /// Fetch event handler  /// increment event handler
  // Stream<CounterStreamState> increment(IncrementCounterEvent event) async* {
  //   // yield CounterStreamState.processing(data: state.data);

  //   try {
  //     final newData = await _repository.increment(count: state.data!);
  //     yield CounterStreamState.successful(data: newData);
  //     await Future.delayed(const Duration(milliseconds: 100));
  //   } on Object catch (error, stackTrace) {
  //     // Логирование ошибки (раскомментируйте строку при необходимости)
  //     // l.e('An error occurred in the CounterBLoC: $error', stackTrace);
  //     yield CounterStreamState.error(data: state.data);
  //   } finally {
  //     yield CounterStreamState.idle(data: state.data);
  //   }
  // }

  // Stream<CounterStreamState> decrement(
  //   DecrementCounterEvent event,
  // ) async* {
  //   // yield CounterStreamState.processing(data: state.data);

  //   try {
  //     final newData = await _repository.decrement(count: state.data!);
  //     yield CounterStreamState.successful(data: newData);
  //     await Future.delayed(const Duration(milliseconds: 100));
  //   } on Object catch (error, stackTrace) {
  //     // Логирование ошибки (раскомментируйте строку при необходимости)
  //     // l.e('An error occurred in the CounterBLoC: $error', stackTrace);
  //     yield CounterStreamState.error(data: state.data);
  //   } finally {
  //     yield CounterStreamState.idle(data: state.data);
  //   }
  // }
}

class CounterControllerReceiver {
  const CounterControllerReceiver(
      {required ICounterRepository repository, required this.state})
      : _repository = repository;

  final ICounterRepository _repository;
  final CounterStreamState state;

  Stream<CounterStreamState> increment(IncrementCounterEvent event) async* {
    // yield CounterStreamState.processing(data: state.data);

    try {
      final newData = await _repository.increment(count: state.data!);
      yield CounterStreamState.successful(data: newData);
      await Future.delayed(const Duration(milliseconds: 100));
    } on Object catch (error, stackTrace) {
      // Логирование ошибки (раскомментируйте строку при необходимости)
      // l.e('An error occurred in the CounterBLoC: $error', stackTrace);
      yield CounterStreamState.error(data: state.data);
    } finally {
      yield CounterStreamState.idle(data: state.data);
    }
  }

  Stream<CounterStreamState> decrement(
    DecrementCounterEvent event,
  ) async* {
    // yield CounterStreamState.processing(data: state.data);

    try {
      final newData = await _repository.decrement(count: state.data!);
      yield CounterStreamState.successful(data: newData);
      await Future.delayed(const Duration(milliseconds: 100));
    } on Object catch (error, stackTrace) {
      // Логирование ошибки (раскомментируйте строку при необходимости)
      // l.e('An error occurred in the CounterBLoC: $error', stackTrace);
      yield CounterStreamState.error(data: state.data);
    } finally {
      yield CounterStreamState.idle(data: state.data);
    }
  }
}

/// Интерфейс команды
sealed class Command<T> {
  abstract final CounterControllerReceiver receiver;

  T execute();
}

/// Конкретная команда
class IncrementCommand implements Command<Stream<CounterStreamState>> {
  const IncrementCommand({required this.receiver, required this.event});

  @override
  final CounterControllerReceiver receiver;

  final IncrementCounterEvent event;

  @override
  Stream<CounterStreamState> execute() => receiver.increment(event);
}

/// Конкретная команда
class DecrementCommand implements Command<Stream<CounterStreamState>> {
  const DecrementCommand({required this.receiver, required this.event});

  @override
  final CounterControllerReceiver receiver;

  final DecrementCounterEvent event;

  @override
  Stream<CounterStreamState> execute() => receiver.decrement(event);
}

/// Отправитель
class CounterControllerInvoker<T> {
  CounterControllerInvoker();

  Command<T>? _lastCommand;
  final List<String> _logs = [];

  T executeCommand(Command<T> command) {
    _lastCommand = command;
    _logs.add('${DateTime.now()} ${command.runtimeType}');
    return command.execute();
  }

  T? repeatLastCommand() {
    final Command<T>? command = _lastCommand;

    if (command != null) return executeCommand<T>(command);
    return null;
  }

  void logHistory() {
    for (final String log in _logs) {
      print(log);
    }
  }
}
