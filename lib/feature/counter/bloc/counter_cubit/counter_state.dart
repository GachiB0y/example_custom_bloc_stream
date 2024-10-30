part of 'counter_cubit.dart';



/// {@template counter_state_placeholder}
/// Entity placeholder for CounterState
/// {@endtemplate}
typedef CounterEntity = int;

/// {@template counter_state}
/// CounterState.
/// {@endtemplate}
sealed class CounterState extends _$CounterStateBase {
  /// Idling state
  /// {@macro counter_state}
  const factory CounterState.idle({
    required CounterEntity? data,
    String message,
  }) = CounterState$Idle;

  /// Processing
  /// {@macro counter_state}
  const factory CounterState.processing({
    required CounterEntity? data,
    String message,
  }) = CounterState$Processing;

  /// Successful
  /// {@macro counter_state}
  const factory CounterState.successful({
    required CounterEntity? data,
    String message,
  }) = CounterState$Successful;

  /// An error has occurred
  /// {@macro counter_state}
  const factory CounterState.error({
    required CounterEntity? data,
    String message,
  }) = CounterState$Error;

  /// {@macro counter_state}
  const CounterState({required super.data, required super.message});
}

/// Idling state
/// {@nodoc}
final class CounterState$Idle extends CounterState with _$CounterState {
  /// {@nodoc}
  const CounterState$Idle({required super.data, super.message = 'Idling'});
}

/// Processing
/// {@nodoc}
final class CounterState$Processing extends CounterState with _$CounterState {
  /// {@nodoc}
  const CounterState$Processing({required super.data, super.message = 'Processing'});
}

/// Successful
/// {@nodoc}
final class CounterState$Successful extends CounterState with _$CounterState {
  /// {@nodoc}
  const CounterState$Successful({required super.data, super.message = 'Successful'});
}

/// Error
/// {@nodoc}
final class CounterState$Error extends CounterState with _$CounterState {
  /// {@nodoc}
  const CounterState$Error({required super.data, super.message = 'An error has occurred.'});
}

/// {@nodoc}
base mixin _$CounterState on CounterState {}

/// Pattern matching for [CounterState].
typedef CounterStateMatch<R, S extends CounterState> = R Function(S state);

/// {@nodoc}
@immutable
abstract base class _$CounterStateBase {
  /// {@nodoc}
  const _$CounterStateBase({required this.data, required this.message});

  /// Data entity payload.
  @nonVirtual
  final CounterEntity? data;

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

  /// Pattern matching for [CounterState].
  R map<R>({
    required CounterStateMatch<R, CounterState$Idle> idle,
    required CounterStateMatch<R, CounterState$Processing> processing,
    required CounterStateMatch<R, CounterState$Successful> successful,
    required CounterStateMatch<R, CounterState$Error> error,
  }) =>
      switch (this) {
        CounterState$Idle s => idle(s),
        CounterState$Processing s => processing(s),
        CounterState$Successful s => successful(s),
        CounterState$Error s => error(s),
        _ => throw AssertionError(),
      };

  /// Pattern matching for [CounterState].
  R maybeMap<R>({
    CounterStateMatch<R, CounterState$Idle>? idle,
    CounterStateMatch<R, CounterState$Processing>? processing,
    CounterStateMatch<R, CounterState$Successful>? successful,
    CounterStateMatch<R, CounterState$Error>? error,
    required R Function() orElse,
  }) =>
      map<R>(
        idle: idle ?? (_) => orElse(),
        processing: processing ?? (_) => orElse(),
        successful: successful ?? (_) => orElse(),
        error: error ?? (_) => orElse(),
      );

  /// Pattern matching for [CounterState].
  R? mapOrNull<R>({
    CounterStateMatch<R, CounterState$Idle>? idle,
    CounterStateMatch<R, CounterState$Processing>? processing,
    CounterStateMatch<R, CounterState$Successful>? successful,
    CounterStateMatch<R, CounterState$Error>? error,
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
