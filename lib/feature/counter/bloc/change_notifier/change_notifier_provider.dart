import 'package:flutter/widgets.dart';

/// Inherited widget for quick access in the element tree.
class ChangeNotifierProvider<T extends Listenable> extends InheritedWidget {
  const ChangeNotifierProvider({
    super.key,
    required this.model,
    required super.child,
  });

  final T model;

  /// The model from the closest instance of this class
  /// that encloses the given context, if any.
  /// For example: `ChangeNotifierProvider.maybeOf(context)`.
  static T? maybeOf<T extends Listenable>(BuildContext context,
      {bool listen = true}) {
    if (listen) {
      final notifier = context
          .dependOnInheritedWidgetOfExactType<ChangeNotifierProvider<T>>();
      return notifier?.model;
    } else {
      final widget = context
          .getElementForInheritedWidgetOfExactType<ChangeNotifierProvider<T>>()
          ?.widget;

      if (widget is ChangeNotifierProvider<T>) {
        return widget.model;
      }
      return null;
    }
  }

  static Never _notFoundInheritedWidgetOfExactType() => throw ArgumentError(
        'Out of scope, not found inherited widget '
            'a ChangeNotifierProvider of the exact type',
        'out_of_scope',
      );

  /// The model from the closest instance of this class
  /// that encloses the given context.
  /// For example: `ChangeNotifierProvider.of(context)`.
  static T? of<T extends Listenable>(BuildContext context,
          {bool listen = true}) =>
      maybeOf(context, listen: listen) ?? _notFoundInheritedWidgetOfExactType();

  @override
  bool updateShouldNotify(covariant ChangeNotifierProvider oldWidget) => false;
}
