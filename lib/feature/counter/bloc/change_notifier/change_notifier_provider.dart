import 'package:flutter/widgets.dart';

/// Inherited widget for quick access in the element tree.
class ChangeNotifierProvider<T extends Listenable>
    extends InheritedNotifier<T> {
  const ChangeNotifierProvider({
    super.key,
    required this.model,
    required super.child,
  }) : super(notifier: model);

  final T? model;

  /// The model from the closest instance of this class
  /// that encloses the given context, if any.
  /// For example: `ChangeNotifierProvider.maybeOf(context)`.
  static T? maybeOf<T extends Listenable>(BuildContext context,
      {bool listen = true}) {
    if (listen) {
      return context
          .dependOnInheritedWidgetOfExactType<ChangeNotifierProvider<T>>()
          ?.notifier;
    } else {
      final widget = context
          .getElementForInheritedWidgetOfExactType<ChangeNotifierProvider<T>>()
          ?.widget;

      return widget is ChangeNotifierProvider<T> ? widget.notifier : null;
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
  bool updateShouldNotify(covariant InheritedNotifier<T> oldWidget) =>
      oldWidget.notifier != notifier || identical(oldWidget.notifier, notifier);
}
