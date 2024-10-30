// Pages and screens, just for the example
import 'package:bloc_stream/app.dart';
import 'package:bloc_stream/feature/catalog/widget/catalog_screen.dart';
import 'package:bloc_stream/feature/category/widget/category_screen.dart';
import 'package:bloc_stream/feature/color/widget/colors_screen.dart';
import 'package:bloc_stream/feature/counter/widget/counter_bloc_screen.dart';
import 'package:bloc_stream/feature/counter/widget/counter_cubit_screen.dart';
import 'package:bloc_stream/feature/product/widget/product_screen.dart';
import 'package:flutter/material.dart';

enum AppPages {
  home('home', title: 'Home'),
  blocCounter('bloc-counter', title: 'Bloc Counter'),
  cubitCounter('cubit-counter', title: 'Cubit Counter'),
  settings('settings', title: 'Settings'),
  bloc('bloc-example', title: 'Bloc Example'),
  catalog('catalog', title: 'Catalog'),
  category('category', title: 'Category'),
  product('product', title: 'Product');

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
    }
  }
}
