import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart' as bloc_concurrency;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_bloc.freezed.dart';
part 'user_bloc_event.dart';
part 'user_bloc_state.dart';

/// Business Logic Component UserBLoC
class UserBLoC extends Bloc<UserEvent, UserState> implements EventSink<UserEvent> {
  UserBLoC({
    required final IUserRepository repository,
    final UserState? initialState,
  }) : _repository = repository,
        super(
          initialState ??
              UserState.idle(
                data: UserEntity(),
                message: 'Initial idle state',
              ),
        ) {
    on<UserEvent>(
      (event, emit) => event.map<Future<void>>(
        fetch: (event) => _fetch(event, emit),
      ),
      transformer: bloc_concurrency.sequential(),
      //transformer: bloc_concurrency.restartable(),
      //transformer: bloc_concurrency.droppable(),
      //transformer: bloc_concurrency.concurrent(),
    );
  }
  
  final IUserRepository _repository;
  
  /// Fetch event handler
  Future<void> _fetch(FetchUserEvent event, Emitter<UserState> emit) async {
    try {
      emit(UserState.processing(data: state.data));
      final newData = await _repository.fetch(event.id);
      emit(UserState.successful(data: newData));
    } on Object catch (err, stackTrace) {
      //l.e('An error occurred in the UserBLoC: $err', stackTrace);
      emit(UserState.error(data: state.data));
      rethrow;
    } finally {
      emit(UserState.idle(data: state.data));
    }
  }
}
