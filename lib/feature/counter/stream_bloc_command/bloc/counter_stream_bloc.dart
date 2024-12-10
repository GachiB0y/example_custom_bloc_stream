// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:collection';

import 'package:bloc_stream/common/model/dependencies.dart';
import 'package:bloc_stream/feature/counter/data/repo/counter_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:stream_bloc/stream_bloc.dart';

part 'counter_stream_event.dart';
part 'counter_stream_state.dart';

class CounterStreamBLoC extends StreamBloc<CounterEvent, CounterStreamState>
    implements EventSink<CounterEvent> {
  CounterStreamBLoC({
    required ICounterRepository repository,
    required this.commandFactory,
    CounterStreamState? initialState,
  })  : _repository = repository,
        super(
          initialState ??
              const CounterStreamState.idle(
                data: 0,
                message: 'Initial idle state',
              ),
        );

  final ICounterRepository _repository;
  final CounterCommandFactory commandFactory;

  @override
  Stream<CounterStreamState> mapEventToStates(CounterEvent event) async* {
    yield* commandFactory
        .createCommant(
          event: event,
        )
        .execute(
          currentState: state,
          event: event,
          repository: _repository,
        );
  }
}

abstract class CounterCommand {
  const CounterCommand();

  Stream<CounterStreamState> execute({
    required CounterStreamState currentState,
    required CounterEvent event,
    required ICounterRepository repository,
  });
}

class IncrementCommand extends CounterCommand {
  const IncrementCommand({required CommandHistory commandHistory})
      : _commandHistory = commandHistory;
  final CommandHistory _commandHistory;

  @override
  Stream<CounterStreamState> execute({
    required CounterStreamState currentState,
    required CounterEvent event,
    required ICounterRepository repository,
  }) async* {
    _commandHistory.add(this, currentState);
    yield CounterStreamState.processing(data: currentState.data);
    int? newData;
    try {
      newData = await repository.increment(count: currentState.data!);
      yield CounterStreamState.successful(data: newData);
    } catch (error, stackTrace) {
      yield CounterStreamState.error(data: currentState.data);
    } finally {
      yield CounterStreamState.idle(data: newData ?? currentState.data);
    }
  }
}

class DecrementCommand extends CounterCommand {
  const DecrementCommand({required CommandHistory commandHistory})
      : _commandHistory = commandHistory;
  final CommandHistory _commandHistory;

  @override
  Stream<CounterStreamState> execute({
    required CounterStreamState currentState,
    required CounterEvent event,
    required ICounterRepository repository,
  }) async* {
    _commandHistory.add(this, currentState);
    yield CounterStreamState.processing(data: currentState.data);
    int? newData;
    try {
      newData = await repository.decrement(count: currentState.data!);
      yield CounterStreamState.successful(data: newData);
    } catch (error, stackTrace) {
      yield CounterStreamState.error(data: currentState.data);
    } finally {
      yield CounterStreamState.idle(data: newData ?? currentState.data);
    }
  }
}

class InitStateCommand extends CounterCommand {
  const InitStateCommand({required CommandHistory commandHistory})
      : _commandHistory = commandHistory;
  final CommandHistory _commandHistory;

  @override
  Stream<CounterStreamState> execute({
    required CounterStreamState currentState,
    required CounterEvent event,
    required ICounterRepository repository,
  }) async* {
    _commandHistory.add(this, currentState);
    // Просто возвращаем текущее состояние
    yield currentState;
  }

  @override
  Stream<CounterStreamState> undo(CounterStreamState previousState) async* {
    yield previousState;
  }
}

abstract class CounterCommandFactory {
  CounterCommand createCommant({
    required CounterEvent event,
  });
}

class FactoryCommand implements CounterCommandFactory {
  FactoryCommand({
    required this.container,
  });

  // final List<CounterCommand> comands;
  final DIConaierCommand container;

  @override
  CounterCommand createCommant({
    required CounterEvent event,
  }) {
    switch (event) {
      case IncrementCounterEvent():
        return container.incrementCommand;
      case DecrementCounterEvent():
        return container.decrementCommand;
      case InitStateCounterEvent():
        return container.initStateCommand;
      case UndoCounterEvent():
        return container.commandHistory;
    }
  }
}

class CommandHistory implements CounterCommand {
  CommandHistory();
  final _commandList = ListQueue<CounterCommand>();

  final _stateList = ListQueue<CounterStreamState>();

  bool get isEmpty => _commandList.isEmpty;
  List<String> get commandHistoryList {
    var list = <String>[];
    for (final CounterCommand log in _commandList) {
      list.add('logHistory:$log');
    }
    return list;
  }

  void add(CounterCommand command, CounterStreamState currentState) {
    _commandList.add(command);

    _stateList.add(currentState);
  }

  @override
  Stream<CounterStreamState> execute({
    required CounterStreamState currentState,
    required CounterEvent event,
    required ICounterRepository repository,
  }) async* {
    if (_commandList.isEmpty || _stateList.isEmpty) return;
    final previousState = _stateList.removeLast();
    _commandList.removeLast();

    yield CounterStreamState.processing(data: previousState.data);
    yield CounterStreamState.successful(data: previousState.data);
    yield CounterStreamState.idle(data: previousState.data);
  }
}
