import 'package:bloc_stream/router/pages.dart';
import 'package:bloc_stream/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// {@template catalog_screen}
/// CatalogScreen widget.
/// {@endtemplate}
class CatalogScreen extends StatelessWidget {
  /// {@macro catalog_screen}
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Catalog'),
        ),
        body: SafeArea(
          child: ListView(
            children: [
              ListTile(
                title: const Text('Wheels'),
                onTap: () => AppNavigator.change(
                  context,
                  (pages) => [
                    ...pages,
                    AppPages.category.page(arguments: {'categoryId': 'wheels'}),
                  ],
                ),
              ),
              ListTile(
                title: const Text('Oils'),
                onTap: () => AppNavigator.change(
                  context,
                  (pages) => [
                    ...pages,
                    AppPages.category.page(arguments: {'categoryId': 'oils'}),
                  ],
                ),
              ),
              ListTile(
                title: const Text('Spares'),
                onTap: () => AppNavigator.change(
                  context,
                  (pages) => [
                    ...pages,
                    AppPages.category.page(arguments: {'categoryId': 'spares'}),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
