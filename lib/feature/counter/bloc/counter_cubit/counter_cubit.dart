import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_stream/feature/counter/data/repo/counter_repo.dart';
import 'package:flutter/foundation.dart';

part 'counter_state.dart';

class CounterCubit extends Cubit<CounterState> {
  CounterCubit({
    required final ICounterRepository repository,
  })  : _repository = repository,
        super(
          const CounterState.idle(
            data: 0,
            message: 'Initial idle state',
          ),
        );

  final ICounterRepository _repository;

  Future<void> increment() async {
    try {
      emit(CounterState.processing(data: state.data));
      final newData = await _repository.increment(count: state.data!);
      emit(CounterState.successful(data: newData));
    } on Object catch (err, stackTrace) {
      emit(CounterState.error(data: state.data));
      rethrow;
    } finally {
      emit(CounterState.idle(data: state.data));
    }
  }

  Future<void> decrement() async {
    try {
      emit(CounterState.processing(data: state.data));
      final newData = await _repository.decrement(count: state.data!);
      emit(CounterState.successful(data: newData));
    } on Object catch (err, stackTrace) {
      emit(CounterState.error(data: state.data));
      rethrow;
    } finally {
      emit(CounterState.idle(data: state.data));
    }
  }
}
