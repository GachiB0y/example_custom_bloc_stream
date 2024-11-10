import 'package:bloc_stream/feature/counter/bloc/counter_stream_bloc/counter_stream_bloc.dart';
import 'package:bloc_stream/feature/counter/data/repo/counter_repo.dart';
import 'package:flutter/material.dart';

class CounterCustomStreamBlocScreen extends StatefulWidget {
  const CounterCustomStreamBlocScreen({super.key});

  @override
  State<CounterCustomStreamBlocScreen> createState() =>
      _CounterCustomStreamBlocScreenState();
}

class _CounterCustomStreamBlocScreenState
    extends State<CounterCustomStreamBlocScreen> {
  late final CounterCustomStreamBloc counterBLoC;

  @override
  void initState() {
    super.initState();
    counterBLoC = CounterCustomStreamBloc(repository: CounterRepo());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Stream'),
      ),
      body: StreamBuilder<CounterStreamState>(
        stream: counterBLoC.stream,
        builder: (context, snaphot) {
          if (!snaphot.hasData) {
            return const Center(child: Text('State is null'));
          }
          if (snaphot.data is CounterStreamState$Idle ||
              snaphot.data is CounterStreamState$Successful) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Counter: ${snaphot.data!.data}',
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
          } else if (snaphot.data is CounterStreamState$Processing) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(child: Text('Error occurred'));
          }
        },
      ),
    );
  }
}
