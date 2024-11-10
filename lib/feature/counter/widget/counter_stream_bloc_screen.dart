import 'package:bloc_stream/feature/counter/bloc/counter_stream_bloc/counter_stream_bloc.dart';
import 'package:bloc_stream/feature/counter/data/repo/counter_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterStreamBlocScreen extends StatefulWidget {
  const CounterStreamBlocScreen({super.key});

  @override
  State<CounterStreamBlocScreen> createState() =>
      _CounterStreamBlocScreenState();
}

class _CounterStreamBlocScreenState extends State<CounterStreamBlocScreen> {
  late final CounterStreamBLoC counterBLoC;

  @override
  void initState() {
    super.initState();
    counterBLoC = CounterStreamBLoC(repository: CounterRepo());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('stream_bloc'),
      ),
      body: BlocBuilder<CounterStreamBLoC, CounterStreamState>(
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
