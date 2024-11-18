import 'package:bloc_stream/feature/counter/data/repo/counter_repo.dart';
import 'package:flutter/widgets.dart';

class CountModel extends ChangeNotifier {
  CountModel({
    required ICounterRepository repository,
    required int initialCount,
  })  : _countModel = initialCount,
        _repository = repository;

  final ICounterRepository _repository;

  /// Internal, private state of the Count.
  int _countModel;

  /// An unmodifiable view of the Count.
  int get count => _countModel;

  /// increments the count
  Future<void> increment() async {
    final newCount = await _repository.increment(count: _countModel);
    _countModel = newCount;

    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// decrements the count
  Future<void> decrement() async {
    final newCount = await _repository.decrement(count: _countModel);
    _countModel = newCount;

    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}
