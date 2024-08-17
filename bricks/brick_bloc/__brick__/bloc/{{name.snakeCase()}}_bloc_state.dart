
part of '{{name.snakeCase()}}_bloc.dart';

/// {@template {{name.pascalCase()}}_placeholder}
/// Entity placeholder for {{name.pascalCase()}}State
/// {@endtemplate}
typedef {{name.pascalCase()}}Entity = Object;

/// {@template {{name.pascalCase()}}}
/// {{name.pascalCase()}}State.
/// {@endtemplate}
sealed class {{name.pascalCase()}}State extends _${{name.pascalCase()}}StateBase {
  /// Idling state
  /// {@macro {{name.pascalCase()}}}
  const factory {{name.pascalCase()}}State.idle({
    required {const {name.pascalCase()}}Entity? data,
    String message,
  }) = {{name.pascalCase()}}State$Idle;

  /// Processing
  /// {@macro {{name.pascalCase()}}}
  const factory {{name.pascalCase()}}State.processing({
    required {const {name.pascalCase()}}Entity? data,
    String message,
  }) = {{name.pascalCase()}}State$Processing;

  /// Successful
  /// {@macro {{name.pascalCase()}}}
  const factory {{name.pascalCase()}}State.successful({
    required {const {name.pascalCase()}}Entity? data,
    String message,
  }) = {{name.pascalCase()}}State$Successful;

  /// An error has occurred
  /// {@macro {{name.pascalCase()}}}
  const factory {{name.pascalCase()}}State.error({
    required {const {name.pascalCase()}}Entity? data,
    String message,
  }) = {{name.pascalCase()}}State$Error;

  /// {@macro {{name.pascalCase()}}}
  const {{name.pascalCase()}}State({required super.data, required super.message});
}

/// Idling state
/// {@nodoc}
final class {{name.pascalCase()}}State$Idle extends {{name.pascalCase()}}State with _${{name.pascalCase()}}State {
  /// {@nodoc}
  const {{name.pascalCase()}}State$Idle({required super.data, super.message = 'Idling'});
}

/// Processing
/// {@nodoc}
final class {{name.pascalCase()}}State$Processing extends {{name.pascalCase()}}State with _${{name.pascalCase()}}State {
  /// {@nodoc}
  const {{name.pascalCase()}}State$Processing({required super.data, super.message = 'Processing'});
}

/// Successful
/// {@nodoc}
final class {{name.pascalCase()}}State$Successful extends {{name.pascalCase()}}State with _${{name.pascalCase()}}State {
  /// {@nodoc}
  const {{name.pascalCase()}}State$Successful({required super.data, super.message = 'Successful'});
}

/// Error
/// {@nodoc}
final class {{name.pascalCase()}}State$Error extends {{name.pascalCase()}}State with _${{name.pascalCase()}}State {
  /// {@nodoc}
  const {{name.pascalCase()}}State$Error({required super.data, super.message = 'An error has occurred.'});
}

/// {@nodoc}
base mixin _${{name.pascalCase()}}State on {{name.pascalCase()}}State {}

/// Pattern matching for [{{name.pascalCase()}}State].
typedef {{name.pascalCase()}}StateMatch<R, S extends {{name.pascalCase()}}State> = R Function(S state);

/// {@nodoc}
@immutable
abstract base class _${{name.pascalCase()}}StateBase {
  /// {@nodoc}
  const ${{name.pascalCase()}}StateBase({required this.data, required this.message});

  /// Data entity payload.
  @nonVirtual
  final {{name.pascalCase()}}Entity? data;

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

  /// Pattern matching for [{{name.pascalCase()}}State].
  R map<R>({
    required {{name.pascalCase()}}StateMatch<R, {{name.pascalCase()}}State$Idle> idle,
    required {{name.pascalCase()}}StateMatch<R, {{name.pascalCase()}}State$Processing> processing,
    required {{name.pascalCase()}}StateMatch<R, {{name.pascalCase()}}State$Successful> successful,
    required {{name.pascalCase()}}StateMatch<R, {{name.pascalCase()}}State$Error> error,
  }) =>
      switch (this) {
        {const const {name.pascalCase()}}State$Idle s => idle(s),
        {const const {name.pascalCase()}}State$Processing s => processing(s),
        {const const {name.pascalCase()}}State$Successful s => successful(s),
        {const const {name.pascalCase()}}State$Error s => error(s),
        _ => throw AssertionError(),
      };

  /// Pattern matching for [{{name.pascalCase()}}State].
  R maybeMap<R>({
    {{name.pascalCase()}}StateMatch<R, {{name.pascalCase()}}State$Idle>? idle,
    {{name.pascalCase()}}StateMatch<R, {{name.pascalCase()}}State$Processing>? processing,
    {{name.pascalCase()}}StateMatch<R, {{name.pascalCase()}}State$Successful>? successful,
    {{name.pascalCase()}}StateMatch<R, {{name.pascalCase()}}State$Error>? error,
    required R Function() orElse,
  }) =>
      map<R>(
        idle: idle ?? (_) => orElse(),
        processing: processing ?? (_) => orElse(),
        successful: successful ?? (_) => orElse(),
        error: error ?? (_) => orElse(),
      );

  /// Pattern matching for [{{name.pascalCase()}}State].
  R? mapOrNull<R>({
    {{name.pascalCase()}}StateMatch<R, {{name.pascalCase()}}State$Idle>? idle,
    {{name.pascalCase()}}StateMatch<R, {{name.pascalCase()}}State$Processing>? processing,
    {{name.pascalCase()}}StateMatch<R, {{name.pascalCase()}}State$Successful>? successful,
    {{name.pascalCase()}}StateMatch<R, {{name.pascalCase()}}State$Error>? error,
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
