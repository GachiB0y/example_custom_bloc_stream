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
        .createCommant(event: event, state: state, repository: _repository)
        .execute();
  }
}

abstract class CounterCommand {
  const CounterCommand();

  Stream<CounterStreamState> execute();

  Stream<CounterStreamState> undo();
}

class IncrementCommand extends CounterCommand {
  const IncrementCommand({
    required this.currentState,
    required this.event,
    required this.repository,
  }) : previousState = currentState;

  final CounterStreamState previousState;
  final CounterStreamState currentState;
  final CounterEvent event;
  final ICounterRepository repository;

  @override
  Stream<CounterStreamState> execute() async* {
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
  const DecrementCommand({
    required this.currentState,
    required this.event,
    required this.repository,
  }) : previousState = currentState;

  final CounterStreamState previousState;
  final CounterStreamState currentState;

  final CounterEvent event;
  final ICounterRepository repository;

  @override
  Stream<CounterStreamState> execute() async* {
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
  Stream<CounterStreamState> execute() async* {
    // Просто возвращаем текущее состояние
    yield currentState;
  }

  @override
  Stream<CounterStreamState> undo() async* {
    yield previousState;
  }
}

abstract class CounterCommandFactory {
  CounterCommand createCommant({
    required CounterEvent event,
    required CounterStreamState state,
    required ICounterRepository repository,
  });
}

class FactoryCommand implements CounterCommandFactory {
  FactoryCommand({
    required this.commandHistory,
    required this.container,
  });

  final CommandHistory commandHistory;
  // final List<CounterCommand> comands;
  final Dependencies container;

  @override
  CounterCommand createCommant({
    required CounterEvent event,
    required CounterStreamState state,
    required ICounterRepository repository,
  }) {
    switch (event) {
      case IncrementCounterEvent incrementCounterEvent:
        return container.incrementCommand;
      case DecrementCounterEvent decrementCounterEvent:
        return DecrementCommand(
          currentState: state,
          event: decrementCounterEvent,
          repository: repository,
        );
      case InitStateCounterEvent initStateCounterEvent:
        return InitStateCommand(state);
      case UndoCounterEvent():
        return commandHistory;
      case redo():
        return commandHistory;
    }
  }
}

class CommandHistory implements CounterCommand {
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

  @override
  Stream<CounterStreamState> undo() async* {
    if (_commandList.isEmpty) return;

    yield* _commandList.removeLast().undo();
  }

  @override
  Stream<CounterStreamState> execute() {
    return _commandList.last.execute();
  }
}
