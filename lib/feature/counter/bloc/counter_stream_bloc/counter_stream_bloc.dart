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
    required final ICounterRepository repository,
    final CounterStreamState? initialState,
  })  : _repository = repository,
        super(
          initialState ??
              const CounterStreamState.idle(
                data: 0,
                message: 'Initial idle state',
              ),
        );

  final ICounterRepository _repository;
  @override
  Stream<CounterStreamState> mapEventToStates(CounterEvent event) async* {
    switch (event) {
      case IncrementCounterEvent incrementCounterEvent:
        yield* increment(incrementCounterEvent);
      case DecrementCounterEvent decrementCounterEvent:
        yield* decrement(decrementCounterEvent);
      default:
        throw UnimplementedError('Unhandled event: $event');
    }
  }

  /// Fetch event handler  /// increment event handler
  Stream<CounterStreamState> increment(IncrementCounterEvent event) async* {
    // yield CounterStreamState.processing(data: state.data);

    try {
      final newData = await _repository.increment(count: state.data!);
      yield CounterStreamState.successful(data: newData);
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
    } on Object catch (error, stackTrace) {
      // Логирование ошибки (раскомментируйте строку при необходимости)
      // l.e('An error occurred in the CounterBLoC: $error', stackTrace);
      yield CounterStreamState.error(data: state.data);
    } finally {
      yield CounterStreamState.idle(data: state.data);
    }
  }
}

class CounterCustomStreamBloc implements Sink<CounterEvent> {
  CounterCustomStreamBloc({
    required final ICounterRepository repository,
  }) : _repository = repository {
    _currentState = const CounterStreamState.idle(
      data: 0,
      message: 'Initial idle state',
    );
    add(const InitStateCounterEvent());
  }
  final ICounterRepository _repository;
  final _inputStreamController = StreamController<CounterEvent>();
  late CounterStreamState _currentState;
  Stream<CounterStreamState> get stream => _stream;
  CounterStreamState get state => _currentState;
  late final Stream<CounterStreamState> _stream = _inputStreamController.stream
      .map((event) {
        print("event: $event");
        return event;
      })
      .asyncExpand(_mapEventToState)
      .map((state) {
        _currentState = state;
        print("state: $state");
        return state;
      })
      .asBroadcastStream();

  Stream<CounterStreamState> _mapEventToState(CounterEvent event) async* {
    switch (event) {
      case IncrementCounterEvent():
        yield* increment(event);
      case DecrementCounterEvent():
        yield* decrement(event);
      case InitStateCounterEvent():
        yield _currentState;
    }
  }

  @override
  void add(CounterEvent event) {
    _inputStreamController.sink.add(event);
  }

  @override
  void close() {
    _inputStreamController.close();
  }

  /// Fetch event handler  /// increment event handler
  Stream<CounterStreamState> increment(IncrementCounterEvent event) async* {
    // yield CounterStreamState.processing(data: state.data);
    try {
      final newData = await _repository.increment(count: state.data!);
      yield CounterStreamState.successful(data: newData);
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
    } on Object catch (error, stackTrace) {
      // Логирование ошибки (раскомментируйте строку при необходимости)
      // l.e('An error occurred in the CounterBLoC: $error', stackTrace);
      yield CounterStreamState.error(data: state.data);
    } finally {
      yield CounterStreamState.idle(data: state.data);
    }
  }
}
