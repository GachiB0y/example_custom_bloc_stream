// import 'package:bloc_stream/feature/counter/bloc/counter_stream_bloc/counter_stream_bloc.dart';
import 'package:bloc_stream/common/bloc/bloc_factory.dart';
import 'package:bloc_stream/common/model/dependencies.dart';
import 'package:bloc_stream/feature/counter/bloc/counter_stream_bloc/counter_stream_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_bloc/stream_bloc.dart';

class CounterStreamBlocScreen extends StatefulWidget {
  const CounterStreamBlocScreen({super.key});

  @override
  State<CounterStreamBlocScreen> createState() =>
      _CounterStreamBlocScreenState();
}

class _CounterStreamBlocScreenState extends State<CounterStreamBlocScreen> {
  late final StreamBloc<CounterEvent, CounterStreamState> counterBLoC;

  @override
  void initState() {
    super.initState();

    // final dicontainer = Dependencies.of(context);
    counterBLoC = Dependencies.of(context).blocFactory.createCounterStreamBloc(
          ConterStreeamBlocType.counterStreamBlocWithCommand,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('stream_bloc'),
      ),
      body: BlocBuilder<StreamBloc<CounterEvent, CounterStreamState>,
          CounterStreamState>(
        bloc: counterBLoC,
        builder: (context, state) {
          if (state is CounterStreamState$Idle ||
              state is CounterStreamState$Successful) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Counter: ${state.data}',
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => counterBLoC.add(
                          const IncrementCounterEvent(),
                        ),
                        child: const Text('Increment'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => counterBLoC.add(
                          const DecrementCounterEvent(),
                        ),
                        child: const Text('Decrement'),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () => counterBLoC.add(
                      const UndoCounterEvent(),
                    ),
                    child: const Text('Undo'),
                  ),
                ],
              ),
            );
          } else if (state is CounterStreamState$Processing) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(child: Text('Error occurred'));
          }
        },
      ),
    );
  }
}
