import 'package:bloc_stream/feature/counter/bloc/counter_cubit/counter_cubit.dart';
import 'package:bloc_stream/feature/counter/data/repo/counter_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterCubitScreen extends StatefulWidget {
  const CounterCubitScreen({super.key});

  @override
  State<CounterCubitScreen> createState() => _CounterCubitScreenState();
}

class _CounterCubitScreenState extends State<CounterCubitScreen> {
  late final CounterCubit counterCubit;

  @override
  void initState() {
    super.initState();
    counterCubit = CounterCubit(repository: CounterRepo());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter Cubit'),
      ),
      body: BlocBuilder<CounterCubit, CounterState>(
        bloc: counterCubit,
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
                        onPressed: () async => await counterCubit.increment(),
                        child: const Text('Increment'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () async => await counterCubit.decrement(),
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
