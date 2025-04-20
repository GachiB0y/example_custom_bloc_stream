import 'dart:math';

import 'package:flutter/rendering.dart';

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

/// Creates grid layouts with a fixed number of tiles in the cross axis, such
/// that the elements in the last row, if fewer than crossAxisCount, are centered.
class SliverGridDelegateWithFixedCrossAxisCountAndCenteredLastRow
    extends SliverGridDelegateWithFixedCrossAxisCount {
  /// The total number of items in the layout.
  final int itemCount;

  SliverGridDelegateWithFixedCrossAxisCountAndCenteredLastRow({
    required this.itemCount,
    required super.crossAxisCount,
    super.mainAxisSpacing,
    super.crossAxisSpacing,
    super.childAspectRatio,
  })  : assert(itemCount >= 0),
        assert(crossAxisCount > 0),
        assert(mainAxisSpacing >= 0),
        assert(crossAxisSpacing >= 0),
        assert(childAspectRatio > 0);

  bool _debugAssertIsValid() {
    assert(crossAxisCount > 0);
    assert(mainAxisSpacing >= 0.0);
    assert(crossAxisSpacing >= 0.0);
    assert(childAspectRatio > 0.0);
    return true;
  }

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    assert(_debugAssertIsValid());
    final usableCrossAxisExtent = max(
      0.0,
      constraints.crossAxisExtent - crossAxisSpacing * (crossAxisCount - 1),
    );
    final childCrossAxisExtent = usableCrossAxisExtent / crossAxisCount;
    final childMainAxisExtent = childCrossAxisExtent / childAspectRatio;

    // Calculate the number of items in the last row
    final itemsInLastRow = itemCount % crossAxisCount == 0
        ? crossAxisCount
        : itemCount % crossAxisCount;
    final lastRowStartIndex = itemCount - itemsInLastRow;

    return SliverGridWithCustomGeometryLayout(
      geometryBuilder: (index, layout) {
        // Check if the current index is in the last row
        if (index >= lastRowStartIndex && itemsInLastRow < crossAxisCount) {
          // Calculate the total width of items in the last row
          final totalItemsWidth = itemsInLastRow * childCrossAxisExtent +
              (itemsInLastRow - 1) * crossAxisSpacing;
          // Calculate the starting offset to center the items
          final startOffset =
              (constraints.crossAxisExtent - totalItemsWidth) / 2;

          // Calculate the position of the current item in the last row
          final itemPositionInLastRow = index - lastRowStartIndex;
          final crossAxisOffset = startOffset +
              itemPositionInLastRow * (childCrossAxisExtent + crossAxisSpacing);

          return SliverGridGeometry(
            scrollOffset: (index ~/ crossAxisCount) * layout.mainAxisStride,
            crossAxisOffset: crossAxisOffset,
            mainAxisExtent: childMainAxisExtent,
            crossAxisExtent: childCrossAxisExtent,
          );
        }

        // For all other rows, use the default offset calculation
        return SliverGridGeometry(
          scrollOffset: (index ~/ crossAxisCount) * layout.mainAxisStride,
          crossAxisOffset: _getOffsetFromStartInCrossAxis(index, layout),
          mainAxisExtent: childMainAxisExtent,
          crossAxisExtent: childCrossAxisExtent,
        );
      },
      crossAxisCount: crossAxisCount,
      mainAxisStride: childMainAxisExtent + mainAxisSpacing,
      crossAxisStride: childCrossAxisExtent + crossAxisSpacing,
      childMainAxisExtent: childMainAxisExtent,
      childCrossAxisExtent: childCrossAxisExtent,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  double _getOffsetFromStartInCrossAxis(
    int index,
    SliverGridRegularTileLayout layout,
  ) {
    final crossAxisStart = (index % crossAxisCount) * layout.crossAxisStride;

    if (layout.reverseCrossAxis) {
      return crossAxisCount * layout.crossAxisStride -
          crossAxisStart -
          layout.childCrossAxisExtent -
          (layout.crossAxisStride - layout.childCrossAxisExtent);
    }
    return crossAxisStart;
  }
}
