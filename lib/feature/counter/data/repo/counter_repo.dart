import 'dart:math';

abstract interface class ICounterRepository {
  Future<int> increment({required int count});
  Future<int> decrement({required int count});
}

class CounterRepo implements ICounterRepository {
  const CounterRepo();
  @override
  Future<int> increment({required int count}) async {
    int newCount = count;
    final int random = Random().nextInt(5);
    newCount++;
    await Future.delayed(Duration(seconds: random));
    return newCount;
  }

  @override
  Future<int> decrement({required int count}) async {
    int newCount = count;
    final int random = Random().nextInt(5);
    newCount--;
    await Future.delayed(Duration(seconds: random));
    return newCount;
  }
}
