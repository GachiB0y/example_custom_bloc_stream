import 'package:bloc_stream/common/bloc/bloc_factory.dart';
import 'package:bloc_stream/feature/counter/bloc/counter_stream_bloc/counter_stream_bloc.dart';
import 'package:bloc_stream/feature/counter/data/repo/counter_repo.dart';
import 'package:bloc_stream/feature/counter/stream_bloc_command/bloc/counter_stream_bloc.dart';
import 'package:stream_bloc/stream_bloc.dart';

class BloCFactory implements IBlocFactory {
  const BloCFactory({
    required this.repository,
    required this.commandFactory,
  });

  final ICounterRepository repository;
  final CounterCommandFactory commandFactory;

  @override
  StreamBloc<CounterEvent, CounterStreamState> createCounterStreamBloc(
      ConterStreeamBlocType type) {
    return switch (type) {
      ConterStreeamBlocType.counterStreamBlocWithCommand =>
        CounterStreamBLoCWithCommand(
          repository: repository,
          commandFactory: commandFactory,
        ),
      ConterStreeamBlocType.counterStreamBlocWithoutCommand =>
        CounterStreamBLoC(
          repository: repository,
        ),
    };
  }
}
