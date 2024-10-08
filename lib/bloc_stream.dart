import 'dart:async';

import 'package:flutter/material.dart';

// /// Пример простого блока, на входе и на выходе стримы

// sealed class ColorsEvent {}

// final class ChangeRedColorEvent implements ColorsEvent {}

// final class ChangeGreenColorEvent implements ColorsEvent {}

// class ColorBloc {
//   ColorBloc() {
//     _inputStreamController.stream.listen(_mapEventToState);
//   }
//   Color _color = Colors.red;

//   final _inputStreamController = StreamController<ColorsEvent>();
//   StreamSink<ColorsEvent> get inputEventSink => _inputStreamController.sink;

//   final _outputStateController = StreamController<Color>();
//   Stream<Color> get outputStateStream => _outputStateController.stream;

//   void _mapEventToState(ColorsEvent event) {
//     switch (event) {
//       case ChangeRedColorEvent():
//         _color = Colors.red;
//         break;
//       case ChangeGreenColorEvent():
//         _color = Colors.green;
//         break;
//       default:
//         throw UnsupportedError('Unhandled event: $event');
//     }

//     _outputStateController.sink.add(_color);
//   }

//   void dispose() {
//     _inputStreamController.close();
//     _outputStateController.close();
//   }
// }

/// Пример блока для поиска, на входе стрим, на выходе стрим через трнасформер выдает стейты
class SearchBloc implements Sink<String> {
  SearchState _state = SearchInitial();
  SearchState get state => _state;

  final _inputStreamController = StreamController<String>();

  late final Stream<SearchState> _stream = _inputStreamController.stream
      // .debounceTime(const Duration(milliseconds: 500)) нужна библа RxDart, ставим событие в очередь и
      //ждем обработки 500 мсБ если событие не поступило - обрабатываем,
      //иначе, если поступило выкидываем тикущее и ставим новове в очередь
      .map((event) {
        debugPrint('event: $event');
        return event;
      })
      //. switchMap(_search) из библы RxDart
      // Использовтаь вместо asyncExpand, т.к. позволяет выкидывать страые события
      // но в отличие от asyncExpand, который продолжает выполнениение события
      // switchMap просто не послает старые данные дальше. Важно понимать что в Dart  нельзя прервать выполнение
      .asyncExpand(_search)
      .map((state) {
        return _state = state;
      })
      .asBroadcastStream();

  Stream<SearchState> get stream => _stream;

  Stream<SearchState> _search(String text) async* {
    yield SearchLoading(text);
    await Future.delayed(const Duration(seconds: 2));
    yield SearchLoaded(text);
  }

  @override
  void add(String event) {
    _inputStreamController.sink.add(event);
  }

  @override
  void close() {
    _inputStreamController.close();
  }
}

sealed class SearchState {}

class SearchInitial implements SearchState {}

class SearchLoading implements SearchState {
  final String text;
  const SearchLoading(this.text);
}

class SearchLoaded implements SearchState {
  final String text;
  const SearchLoaded(this.text);
}

class SearchError implements SearchState {}
