import 'dart:async';

import 'package:flutter/material.dart';

sealed class ColorsEvent {}

final class ChangeRedColorEvent implements ColorsEvent {}

final class InitColorEvent implements ColorsEvent {}

final class ChangeGreenColorEvent implements ColorsEvent {}

/// Пример блока с цветом, на входе стрим, на выходе стрим через трнасформер выдает стейты
sealed class ColorBoxState {}

class ColorBoxInitial implements ColorBoxState {
  final Color color;
  const ColorBoxInitial(this.color);
}

class ColorBoxLoading implements ColorBoxState {}

class ColorBoxLoaded implements ColorBoxState {
  final Color color;
  const ColorBoxLoaded(this.color);
}

class ColorBoxError implements ColorBoxState {}

class ColorBoxBloc implements Sink<ColorsEvent> {
  ColorBoxBloc() {
    _inputStreamController.sink.add(InitColorEvent());
  }
  ColorBoxState _state = const ColorBoxInitial(Colors.pink);
  ColorBoxState get state => _state;

  final _inputStreamController = StreamController<ColorsEvent>();
  late final Stream<ColorBoxState> _stream = _inputStreamController.stream
      .map((event) {
        debugPrint('event: $event');
        return event;
      })
      .asyncExpand(_mapEventToState)
      .map((state) {
        debugPrint('state: $state');
        return _state = state;
      })
      .asBroadcastStream();

  Stream<ColorBoxState> get stream => _stream;

  Stream<ColorBoxState> _mapEventToState(ColorsEvent event) async* {
    yield ColorBoxLoading();
    await Future.delayed(const Duration(seconds: 2));

    switch (event) {
      case ChangeRedColorEvent():
        yield const ColorBoxLoaded(Colors.red);

      case ChangeGreenColorEvent():
        yield const ColorBoxLoaded(Colors.green);

      case InitColorEvent():
        yield const ColorBoxInitial(Colors.pink);

      default:
        throw UnsupportedError('Unhandled event: $event');
    }
  }

  @override
  void add(ColorsEvent data) {
    _inputStreamController.sink.add(data);
  }

  @override
  void close() {
    _inputStreamController.close();
  }
}
