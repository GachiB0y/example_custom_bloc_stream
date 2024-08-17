
part of 'user_bloc_state.dart';

/// {@template User_placeholder}
/// Entity placeholder for UserState
/// {@endtemplate}
typedef UserEntity = Object;

/// {@template User}
/// UserState.
/// {@endtemplate}
sealed class UserState extends _$UserStateBase {
  /// Idling state
  /// {@macro User}
  const factory UserState.idle({
    required {const {name.pascalCase()}}Entity? data,
    String message,
  }) = UserState$Idle;

  /// Processing
  /// {@macro User}
  const factory UserState.processing({
    required {const {name.pascalCase()}}Entity? data,
    String message,
  }) = UserState$Processing;

  /// Successful
  /// {@macro User}
  const factory UserState.successful({
    required {const {name.pascalCase()}}Entity? data,
    String message,
  }) = UserState$Successful;

  /// An error has occurred
  /// {@macro User}
  const factory UserState.error({
    required {const {name.pascalCase()}}Entity? data,
    String message,
  }) = UserState$Error;

  /// {@macro User}
  const UserState({required super.data, required super.message});
}

/// Idling state
/// {@nodoc}
final class UserState$Idle extends UserState with _$UserState {
  /// {@nodoc}
  const UserState$Idle({required super.data, super.message = 'Idling'});
}

/// Processing
/// {@nodoc}
final class UserState$Processing extends UserState with _$UserState {
  /// {@nodoc}
  const UserState$Processing({required super.data, super.message = 'Processing'});
}

/// Successful
/// {@nodoc}
final class UserState$Successful extends UserState with _$UserState {
  /// {@nodoc}
  const UserState$Successful({required super.data, super.message = 'Successful'});
}

/// Error
/// {@nodoc}
final class UserState$Error extends UserState with _$UserState {
  /// {@nodoc}
  const UserState$Error({required super.data, super.message = 'An error has occurred.'});
}

/// {@nodoc}
base mixin _$UserState on UserState {}

/// Pattern matching for [UserState].
typedef UserStateMatch<R, S extends UserState> = R Function(S state);

/// {@nodoc}
@immutable
abstract base class _$UserStateBase {
  /// {@nodoc}
  const $UserStateBase({required this.data, required this.message});

  /// Data entity payload.
  @nonVirtual
  final UserEntity? data;

  /// Message or state description.
  @nonVirtual
  final String message;

  /// Has data?
  bool get hasData => data != null;

  /// If an error has occurred?
  bool get hasError => maybeMap<bool>(orElse: () => false, error: (_) => true);

  /// Is in progress state?
  bool get isProcessing => maybeMap<bool>(orElse: () => false, processing: (_) => true);

  /// Is in idle state?
  bool get isIdling => !isProcessing;

  /// Pattern matching for [UserState].
  R map<R>({
    required UserStateMatch<R, UserState$Idle> idle,
    required UserStateMatch<R, UserState$Processing> processing,
    required UserStateMatch<R, UserState$Successful> successful,
    required UserStateMatch<R, UserState$Error> error,
  }) =>
      switch (this) {
        {const const {name.pascalCase()}}State$Idle s => idle(s),
        {const const {name.pascalCase()}}State$Processing s => processing(s),
        {const const {name.pascalCase()}}State$Successful s => successful(s),
        {const const {name.pascalCase()}}State$Error s => error(s),
        _ => throw AssertionError(),
      };

  /// Pattern matching for [UserState].
  R maybeMap<R>({
    UserStateMatch<R, UserState$Idle>? idle,
    UserStateMatch<R, UserState$Processing>? processing,
    UserStateMatch<R, UserState$Successful>? successful,
    UserStateMatch<R, UserState$Error>? error,
    required R Function() orElse,
  }) =>
      map<R>(
        idle: idle ?? (_) => orElse(),
        processing: processing ?? (_) => orElse(),
        successful: successful ?? (_) => orElse(),
        error: error ?? (_) => orElse(),
      );

  /// Pattern matching for [UserState].
  R? mapOrNull<R>({
    UserStateMatch<R, UserState$Idle>? idle,
    UserStateMatch<R, UserState$Processing>? processing,
    UserStateMatch<R, UserState$Successful>? successful,
    UserStateMatch<R, UserState$Error>? error,
  }) =>
      map<R?>(
        idle: idle ?? (_) => null,
        processing: processing ?? (_) => null,
        successful: successful ?? (_) => null,
        error: error ?? (_) => null,
      );

  @override
  int get hashCode => data.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other);
}
