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
        break;
      case DecrementCounterEvent decrementCounterEvent:
        yield* decrement(decrementCounterEvent);
        break;
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
