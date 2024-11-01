part of 'counter_stream_bloc.dart';

/// {@template counter_stream_state_placeholder}
/// Entity placeholder for CounterStreamState
/// {@endtemplate}
typedef CounterStreamEntity = int;

/// {@template counter_stream_state}
/// CounterStreamState.
/// {@endtemplate}
sealed class CounterStreamState extends _$CounterStreamStateBase {
  /// Idling state
  /// {@macro counter_stream_state}
  const factory CounterStreamState.idle({
    required CounterStreamEntity? data,
    String message,
  }) = CounterStreamState$Idle;

  /// Processing
  /// {@macro counter_stream_state}
  const factory CounterStreamState.processing({
    required CounterStreamEntity? data,
    String message,
  }) = CounterStreamState$Processing;

  /// Successful
  /// {@macro counter_stream_state}
  const factory CounterStreamState.successful({
    required CounterStreamEntity? data,
    String message,
  }) = CounterStreamState$Successful;

  /// An error has occurred
  /// {@macro counter_stream_state}
  const factory CounterStreamState.error({
    required CounterStreamEntity? data,
    String message,
  }) = CounterStreamState$Error;

  /// {@macro counter_stream_state}
  const CounterStreamState({required super.data, required super.message});
}

/// Idling state
/// {@nodoc}
final class CounterStreamState$Idle extends CounterStreamState with _$CounterStreamState {
  /// {@nodoc}
  const CounterStreamState$Idle({required super.data, super.message = 'Idling'});
}

/// Processing
/// {@nodoc}
final class CounterStreamState$Processing extends CounterStreamState with _$CounterStreamState {
  /// {@nodoc}
  const CounterStreamState$Processing({required super.data, super.message = 'Processing'});
}

/// Successful
/// {@nodoc}
final class CounterStreamState$Successful extends CounterStreamState with _$CounterStreamState {
  /// {@nodoc}
  const CounterStreamState$Successful({required super.data, super.message = 'Successful'});
}

/// Error
/// {@nodoc}
final class CounterStreamState$Error extends CounterStreamState with _$CounterStreamState {
  /// {@nodoc}
  const CounterStreamState$Error({required super.data, super.message = 'An error has occurred.'});
}

/// {@nodoc}
base mixin _$CounterStreamState on CounterStreamState {}

/// Pattern matching for [CounterStreamState].
typedef CounterStreamStateMatch<R, S extends CounterStreamState> = R Function(S state);

/// {@nodoc}
@immutable
abstract base class _$CounterStreamStateBase {
  /// {@nodoc}
  const _$CounterStreamStateBase({required this.data, required this.message});

  /// Data entity payload.
  @nonVirtual
  final CounterStreamEntity? data;

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

  /// Pattern matching for [CounterStreamState].
  R map<R>({
    required CounterStreamStateMatch<R, CounterStreamState$Idle> idle,
    required CounterStreamStateMatch<R, CounterStreamState$Processing> processing,
    required CounterStreamStateMatch<R, CounterStreamState$Successful> successful,
    required CounterStreamStateMatch<R, CounterStreamState$Error> error,
  }) =>
      switch (this) {
        CounterStreamState$Idle s => idle(s),
        CounterStreamState$Processing s => processing(s),
        CounterStreamState$Successful s => successful(s),
        CounterStreamState$Error s => error(s),
        _ => throw AssertionError(),
      };

  /// Pattern matching for [CounterStreamState].
  R maybeMap<R>({
    CounterStreamStateMatch<R, CounterStreamState$Idle>? idle,
    CounterStreamStateMatch<R, CounterStreamState$Processing>? processing,
    CounterStreamStateMatch<R, CounterStreamState$Successful>? successful,
    CounterStreamStateMatch<R, CounterStreamState$Error>? error,
    required R Function() orElse,
  }) =>
      map<R>(
        idle: idle ?? (_) => orElse(),
        processing: processing ?? (_) => orElse(),
        successful: successful ?? (_) => orElse(),
        error: error ?? (_) => orElse(),
      );

  /// Pattern matching for [CounterStreamState].
  R? mapOrNull<R>({
    CounterStreamStateMatch<R, CounterStreamState$Idle>? idle,
    CounterStreamStateMatch<R, CounterStreamState$Processing>? processing,
    CounterStreamStateMatch<R, CounterStreamState$Successful>? successful,
    CounterStreamStateMatch<R, CounterStreamState$Error>? error,
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
