// Pages and screens, just for the example
import 'package:bloc_stream/app.dart';
import 'package:bloc_stream/feature/calendar/widget/calendar_screen.dart';
import 'package:bloc_stream/feature/catalog/widget/catalog_screen.dart';
import 'package:bloc_stream/feature/category/widget/category_screen.dart';
import 'package:bloc_stream/feature/color/widget/colors_screen.dart';
import 'package:bloc_stream/feature/counter/widget/counter_bloc_screen.dart';
import 'package:bloc_stream/feature/counter/widget/counter_cubit_screen.dart';
import 'package:bloc_stream/feature/counter/widget/counter_custom_stream_bloc.dart';
import 'package:bloc_stream/feature/counter/widget/counter_notifier_screen.dart';
import 'package:bloc_stream/feature/counter/widget/counter_stream_bloc_screen.dart';
import 'package:bloc_stream/feature/product/widget/product_screen.dart';
import 'package:flutter/material.dart';

enum AppPages {
  home('home', title: 'Home'),
  counterNotifier('counter-notifier', title: 'Counter Notifier'),
  blocCounter('bloc-counter', title: 'Bloc Counter'),
  blocStreamCounter('bloc-stream-counter', title: 'Bloc Stream Counter'),
  blocCustomStreamCounter('bloc-custom-stream-counter',
      title: 'Bloc Custom Stream Counter'),

  cubitCounter('cubit-counter', title: 'Cubit Counter'),
  settings('settings', title: 'Settings'),
  bloc('bloc-example', title: 'Bloc Example'),
  catalog('catalog', title: 'Catalog'),
  category('category', title: 'Category'),
  product('product', title: 'Product'),

  calendar('calendar', title: 'Calendar'),
  ;

  const AppPages(this.name, {this.title});

  final String name;

  final String? title;

  // Метод для получения страницы с передачей аргументов
  Page<Object?> page({Map<String, String>? arguments}) => MaterialPage<Object?>(
        key:
            ValueKey<Object>(arguments == null ? this : arguments.values.first),
        child: Builder(builder: (context) {
          return builder(context, arguments);
        }),
      );

  // Обновленный метод builder с поддержкой аргументов
  Widget builder(BuildContext context, Map<String, String>? arguments) {
    switch (this) {
      case AppPages.home:
        return const HomeScreen();
      case AppPages.settings:
        return const SettingScreen();
      case AppPages.bloc:
        return const ColorBlocSreen();
      case AppPages.catalog:
        return const CatalogScreen();
      case AppPages.category:
        return CategoryScreen(categoryId: arguments!['categoryId']!);
      case AppPages.product:
        return ProductScreen(
            productId: int.tryParse(arguments!['productId'] ?? '0') ?? 0);
      case AppPages.blocCounter:
        return const CounterBlocScreen();
      case AppPages.cubitCounter:
        return const CounterCubitScreen();
      case AppPages.blocStreamCounter:
        return const CounterStreamBlocScreen();
      case AppPages.blocCustomStreamCounter:
        return const CounterCustomStreamBlocScreen();
      case AppPages.counterNotifier:
        return const CounterNotifierScreen();
      case AppPages.calendar:
        return const CalendarScreen();
    }
  }
}
