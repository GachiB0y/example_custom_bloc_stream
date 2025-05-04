import 'package:bloc_stream/loader_itl.dart';
import 'package:bloc_stream/sliver_grid_deleaget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Ваш код для SliverGridWithCustomGeometryLayout и SliverGridDelegateWithFixedCrossAxisCountAndCentralizedLastElement
// (предполагается, что он уже определен, я его не дублирую для краткости)

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Centered Last Element Grid')),
        body: const SplashScreen(),
      ),
    );
  }
}

class MyGridView extends StatelessWidget {
  const MyGridView({super.key});

  @override
  Widget build(BuildContext context) {
    const int itemCount = 1; // Количество элементов
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: CustomScrollView(
        slivers: [
          SliverGrid.builder(
            // padding: const EdgeInsets.all(16.0),
            itemCount: itemCount,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCountAndCenteredLastRow(
              itemCount: itemCount,
              crossAxisCount: 3, // 3 элемента в строке
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              childAspectRatio: 1.0,
            ),
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Text(
                    'Item $index',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// A [SliverGridLayout] that provide a way to customize the children geometry.
class SliverGridWithCustomGeometryLayout extends SliverGridRegularTileLayout {
  /// The builder for each child geometry.
  final SliverGridGeometry Function(
    int index,
    SliverGridRegularTileLayout layout,
  ) geometryBuilder;

  const SliverGridWithCustomGeometryLayout({
    required this.geometryBuilder,
    required super.crossAxisCount,
    required super.mainAxisStride,
    required super.crossAxisStride,
    required super.childMainAxisExtent,
    required super.childCrossAxisExtent,
    required super.reverseCrossAxis,
  })  : assert(crossAxisCount > 0),
        assert(mainAxisStride >= 0),
        assert(crossAxisStride >= 0),
        assert(childMainAxisExtent >= 0),
        assert(childCrossAxisExtent >= 0);

  @override
  SliverGridGeometry getGeometryForChildIndex(int index) {
    return geometryBuilder(index, this);
  }
}
