import 'package:bloc_stream/feature/counter/bloc/change_notifier/change_notifier_provider.dart';
import 'package:bloc_stream/feature/counter/bloc/change_notifier/counter_model.dart';
import 'package:bloc_stream/feature/counter/data/repo/counter_repo.dart';
import 'package:flutter/material.dart';

class CounterNotifierScreen extends StatefulWidget {
  const CounterNotifierScreen({super.key});

  @override
  State<CounterNotifierScreen> createState() => _CounterNotifierScreenState();
}

class _CounterNotifierScreenState extends State<CounterNotifierScreen> {
  late final CountModel counterModel;

  @override
  void initState() {
    super.initState();
    counterModel = CountModel(repository: const CounterRepo(), initialCount: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter Notifier'),
      ),
      body: ChangeNotifierProvider<CountModel>(
          model: counterModel, child: const BodyWidget()),
    );
  }
}

class BodyWidget extends StatelessWidget {
  const BodyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Counter: ${ChangeNotifierProvider.of<CountModel>(context)?.count}',
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async =>
                    await ChangeNotifierProvider.maybeOf<CountModel>(context,
                            listen: false)
                        ?.increment(),
                child: const Text('Increment'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () async =>
                    await ChangeNotifierProvider.maybeOf<CountModel>(context,
                            listen: false)
                        ?.decrement(),
                child: const Text('Decrement'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
