import 'package:bloc_stream/feature/counter/bloc/counter_stream_bloc/counter_stream_bloc.dart';
import 'package:stream_bloc/stream_bloc.dart';

abstract interface class IBlocFactory {
  StreamBloc<CounterEvent, CounterStreamState> createCounterStreamBloc(
    ConterStreeamBlocType type,
  );
}

enum ConterStreeamBlocType {
  counterStreamBlocWithCommand,
  counterStreamBlocWithoutCommand,
}
