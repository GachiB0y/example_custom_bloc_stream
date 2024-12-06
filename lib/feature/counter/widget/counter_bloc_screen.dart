import 'package:bloc_stream/feature/counter/bloc/counter_bloc/counter_bloc.dart';
import 'package:bloc_stream/feature/counter/data/repo/counter_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterBlocScreen extends StatefulWidget {
  const CounterBlocScreen({super.key});

  @override
  State<CounterBlocScreen> createState() => _CounterBlocScreenState();
}

class _CounterBlocScreenState extends State<CounterBlocScreen> {
  late final CounterBLoC counterBLoC;

  @override
  void initState() {
    super.initState();
    counterBLoC = CounterBLoC(repository: const CounterRepo());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter BLoC'),
      ),
      body: BlocBuilder<CounterBLoC, CounterState>(
        bloc: counterBLoC,
        builder: (context, state) {
          if (state is CounterState$Idle || state is CounterState$Successful) {
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
          } else if (state is CounterState$Processing) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(child: Text('Error occurred'));
          }
        },
      ),
    );
  }
}
