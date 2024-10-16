import 'dart:async';

import 'package:flutter/services.dart';

abstract interface class Bloc {
  void dispose();
}

class DeeplinkBloc implements Bloc {
  static const stream = EventChannel('volkov.eventChannel/deeplink');
  static const method = MethodChannel('volkov.methodChannel/deeplink');

  final StreamController<String> _stateController = StreamController();

  Stream<String> get state => _stateController.stream;
  Sink<String> get stateSink => _stateController.sink;
  //Adding the listener into contructor
  DeeplinkBloc() {
    //Checking application start by deep link
    startUri().then(_onRedirected);
    //Checking broadcast stream, if deep link was clicked in opened appication
    stream.receiveBroadcastStream().listen((d) => _onRedirected(d));
  }

  _onRedirected(String? uri) {
    // Here can be any uri analysis, checking tokens etc, if it’s necessary
    // Throw deep link URI into the BloC's stream
    if (uri == null) return;
    stateSink.add(uri);
  }

  @override
  void dispose() {
    _stateController.close();
  }

  Future<String?> startUri() async {
    try {
      return method.invokeMethod('initialLink');
    } on PlatformException catch (e) {
      return "Failed to Invoke: '${e.message}'.";
    }
  }
}