import 'package:bloc_stream/feature/color/bloc/color_bloc.dart';
import 'package:flutter/material.dart';

/// {@template main}
/// ColorBlocSreen widget.
/// {@endtemplate}
class ColorBlocSreen extends StatefulWidget {
  /// {@macro main}
  const ColorBlocSreen({super.key});

  /// The state from the closest instance of this class
  /// that encloses the given context, if any.
  static _ColorBlocSreenState? maybeOf(BuildContext context) =>
      context.findAncestorStateOfType<_ColorBlocSreenState>();

  @override
  State<ColorBlocSreen> createState() => _ColorBlocSreenState();
}

/// State for widget MyHomePage.
class _ColorBlocSreenState extends State<ColorBlocSreen> {
  /* #region Lifecycle */
  final ColorBoxBloc _colorBloc = ColorBoxBloc();
  @override
  void initState() {
    super.initState();
    // Initial state initialization
  }

  @override
  void didUpdateWidget(ColorBlocSreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Widget configuration changed
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // The configuration of InheritedWidgets has changed
    // Also called after initState but before build
  }

  @override
  void dispose() {
    // Permanent removal of a tree stent
    _colorBloc.close();
    super.dispose();
  }
  /* #endregion */

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Bloc with stream'),
        ),
        body: Center(
          child: StreamBuilder<ColorBoxState>(
            stream: _colorBloc.stream,
            // initialData: Colors.red,
            builder: (context, snapshot) {
              if (snapshot.data is ColorBoxLoading) {
                return const CircularProgressIndicator();
              } else if (snapshot.data is ColorBoxLoaded) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: 100,
                  height: 100,
                  color: (snapshot.data as ColorBoxLoaded).color,
                );
              } else if (snapshot.data is ColorBoxInitial) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: 100,
                  height: 100,
                  color: (snapshot.data as ColorBoxInitial).color,
                );
              } else {
                return const Text('Error');
              }
            },
          ),
        ),
        floatingActionButton:
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
            heroTag: 'red',
            backgroundColor: Colors.red,
            onPressed: () {
              _colorBloc.add(ChangeRedColorEvent());
            },
          ),
          FloatingActionButton(
            heroTag: 'green',
            backgroundColor: Colors.green,
            onPressed: () {
              _colorBloc.add(ChangeGreenColorEvent());
            },
          ),
        ]),
      );
}
