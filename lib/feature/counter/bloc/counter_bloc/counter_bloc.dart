import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart' as bloc_concurrency;
import 'package:bloc_stream/feature/counter/data/repo/counter_repo.dart';
import 'package:flutter/foundation.dart';

part 'counter_event.dart';
part 'counter_state.dart';

/// Business Logic Component CounterBLoC
class CounterBLoC extends Bloc<CounterEvent, CounterState>
    implements EventSink<CounterEvent> {
  CounterBLoC({
    required final ICounterRepository repository,
    final CounterState? initialState,
  })  : _repository = repository,
        super(
          initialState ??
              const CounterState.idle(
                data: 0,
                message: 'Initial idle state',
              ),
        ) {
    on<CounterEvent>(
      (event, emit) => switch (event) {
        IncrementCounterEvent incrementCounterEvent =>
          _increment(incrementCounterEvent, emit),
        DecrementCounterEvent decrementCounterEvent =>
          _decrement(decrementCounterEvent, emit),
      },
      //  event.map<Future<void>>(
      //   fetch: (event) => _fetch(event, emit),
      // ),
      transformer: bloc_concurrency.sequential(),
      //transformer: bloc_concurrency.restartable(),
      //transformer: bloc_concurrency.droppable(),
      //transformer: bloc_concurrency.concurrent(),
    );
  }

  final ICounterRepository _repository;

  /// increment event handler
  Future<void> _increment(
      IncrementCounterEvent event, Emitter<CounterState> emit) async {
    try {
      emit(CounterState.processing(data: state.data));
      final newData = await _repository.increment(count: state.data!);
      emit(CounterState.successful(data: newData));
    } on Object catch (err, stackTrace) {
      //l.e('An error occurred in the CounterBLoC: $err', stackTrace);
      emit(CounterState.error(data: state.data));
      rethrow;
    } finally {
      emit(CounterState.idle(data: state.data));
    }
  }

  Future<void> _decrement(
      DecrementCounterEvent event, Emitter<CounterState> emit) async {
    try {
      emit(CounterState.processing(data: state.data));
      final newData = await _repository.decrement(count: state.data!);
      emit(CounterState.successful(data: newData));
    } on Object catch (err, stackTrace) {
      //l.e('An error occurred in the CounterBLoC: $err', stackTrace);
      emit(CounterState.error(data: state.data));
      rethrow;
    } finally {
      emit(CounterState.idle(data: state.data));
    }
  }
}
