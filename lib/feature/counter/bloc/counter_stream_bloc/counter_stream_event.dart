part of 'counter_stream_bloc.dart';

// Business Logic Component Counter Events
sealed class CounterEvent {
  const CounterEvent();
}

// Increment
class IncrementCounterEvent extends CounterEvent {
  const IncrementCounterEvent();
}

// Decrement
class DecrementCounterEvent extends CounterEvent {
  const DecrementCounterEvent();
}
