import 'dart:async';

import 'package:bloc_stream/router/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DeeplinkBloc implements Sink<String> {
  //Adding the listener into contructor
  DeeplinkBloc() {
    //Checking application start by deep link
    startUri().then(_onRedirected);
    //Checking broadcast stream, if deep link was clicked in opened appication
    stream.receiveBroadcastStream().listen((d) => _onRedirected(d));
  }

  static const stream = EventChannel('volkov.eventChannel/deeplink');
  static const method = MethodChannel('volkov.methodChannel/deeplink');

  final StreamController<String> _inputStreamController = StreamController();

  // Stream<String> get state => _inputStreamController.stream;

  List<Page<Object?>> _state = [];
  List<Page<Object?>> get state => _state;

  Stream<List<Page<Object?>>> get streamOutPut => _stream;

  late final Stream<List<Page<Object?>>> _stream = _inputStreamController.stream
      .map((deepLink) {
        debugPrint('deepLink: $deepLink');
        return deepLink;
      })
      .asyncExpand(_mapEventToState)
      .map((state) {
        debugPrint('state: $state');
        return _state = state;
      })
      .asBroadcastStream();

  Stream<List<Page<Object?>>> _mapEventToState(String deepLink) async* {
    if (deepLink.contains('/product')) {
      yield [
        AppPages.catalog.page(),
        AppPages.category.page(arguments: {'categoryId': 'wheels'}),
        AppPages.product.page(arguments: {'productId': 'product deeplinks'}),
      ];
    }
  }

  _onRedirected(String? uri) {
    // Here can be any uri analysis, checking tokens etc, if it’s necessary
    // Throw deep link URI into the BloC's stream
    if (uri == null) return;
    _inputStreamController.sink.add(uri);
  }

  @override
  void close() {
    _inputStreamController.close();
  }

  Future<String?> startUri() async {
    try {
      return method.invokeMethod('initialLink');
    } on PlatformException catch (e) {
      return "Failed to Invoke: '${e.message}'.";
    }
  }

  @override
  void add(String? uri) {
    if (uri == null) return;
    _inputStreamController.sink.add(uri);
  }
}
