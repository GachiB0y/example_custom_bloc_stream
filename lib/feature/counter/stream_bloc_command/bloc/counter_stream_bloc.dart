// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:collection';

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
    yield* commandFactory.executeCommand(
        event: event, currentState: state, repository: _repository);
  }
}

abstract class CounterCommand {
  const CounterCommand();

  Stream<CounterStreamState> execute({
    required CounterEvent event,
    required ICounterRepository repository,
  });

  Stream<CounterStreamState> undo();
}

class IncrementCommand extends CounterCommand {
  const IncrementCommand(this.currentState) : previousState = currentState;

  final CounterStreamState previousState;
  final CounterStreamState currentState;

  @override
  Stream<CounterStreamState> execute({
    required CounterEvent event,
    required ICounterRepository repository,
  }) async* {
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

  @override
  Stream<CounterStreamState> undo() async* {
    yield CounterStreamState.processing(data: previousState.data);
    yield CounterStreamState.successful(data: previousState.data);
    yield CounterStreamState.idle(data: previousState.data);
  }
}

class DecrementCommand extends CounterCommand {
  const DecrementCommand(this.currentState) : previousState = currentState;

  final CounterStreamState previousState;
  final CounterStreamState currentState;

  @override
  Stream<CounterStreamState> execute({
    required CounterEvent event,
    required ICounterRepository repository,
  }) async* {
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

  @override
  Stream<CounterStreamState> undo() async* {
    yield CounterStreamState.processing(data: previousState.data);
    yield CounterStreamState.successful(data: previousState.data);
    yield CounterStreamState.idle(data: previousState.data);
  }
}

class InitStateCommand extends CounterCommand {
  const InitStateCommand(this.currentState) : previousState = currentState;

  final CounterStreamState previousState;
  final CounterStreamState currentState;

  @override
  Stream<CounterStreamState> execute({
    required CounterEvent event,
    required ICounterRepository repository,
  }) async* {
    // Просто возвращаем текущее состояние
    yield currentState;
  }

  @override
  Stream<CounterStreamState> undo() async* {
    yield previousState;
  }
}

abstract class CounterCommandFactory {
  Stream<CounterStreamState> executeCommand({
    required CounterEvent event,
    required CounterStreamState currentState,
    required ICounterRepository repository,
  });
}

class DefaultCounterCommandFactory implements CounterCommandFactory {
  const DefaultCounterCommandFactory(this._commandHistory);
  final CommandHistory _commandHistory;
  @override
  Stream<CounterStreamState> executeCommand({
    required CounterEvent event,
    required CounterStreamState currentState,
    required ICounterRepository repository,
  }) {
    switch (event) {
      case IncrementCounterEvent incrementCounterEvent:
        _commandHistory.add(IncrementCommand(currentState));
        return IncrementCommand(currentState)
            .execute(repository: repository, event: incrementCounterEvent);
      case DecrementCounterEvent decrementCounterEvent:
        _commandHistory.add(IncrementCommand(currentState));
        return DecrementCommand(currentState)
            .execute(repository: repository, event: decrementCounterEvent);
      case InitStateCounterEvent initStateCounterEvent:
        _commandHistory.add(IncrementCommand(currentState));
        return InitStateCommand(currentState)
            .execute(repository: repository, event: initStateCounterEvent);
      case UndoCounterEvent():
        return _commandHistory.undo();
    }
  }
}

class CommandHistory {
  final _commandList = ListQueue<CounterCommand>();

  bool get isEmpty => _commandList.isEmpty;
  List<String> get commandHistoryList {
    var list = <String>[];
    for (final CounterCommand log in _commandList) {
      list.add('logHistory:$log');
    }
    return list;
  }

  void add(CounterCommand command) => _commandList.add(command);

  Stream<CounterStreamState> undo() async* {
    if (_commandList.isEmpty) return;

    yield* _commandList.removeLast().undo();
  }
}
