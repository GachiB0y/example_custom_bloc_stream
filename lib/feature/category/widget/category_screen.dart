import 'package:bloc_stream/router/pages.dart';
import 'package:bloc_stream/router/router.dart';
import 'package:flutter/material.dart';

/// {@template category_screen}
/// CategoryScreen widget.
/// {@endtemplate}
class CategoryScreen extends StatelessWidget {
  /// {@macro category_screen}
  const CategoryScreen({super.key, required this.categoryId});
  final String categoryId;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Category:$categoryId'),
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            // --- Subcategories --- //

            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final subCategoryId = '$categoryId-$index';
                  return ListTile(
                    title: Text('SubCategory: $subCategoryId'),
                    onTap: () => AppNavigator.change(
                      context,
                      (pages) => [
                        ...pages,
                        AppPages.category
                            .page(arguments: {'categoryId': subCategoryId}),
                      ],
                    ),
                  );
                },
                childCount: 5,
              ),
            ),
            const SliverToBoxAdapter(
              child: Divider(height: 10),
            ),
            // --- Priducts --- //

            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final productId = categoryId.hashCode + index;
                  return ListTile(
                    title: Text('Product: $productId'),
                    onTap: () => AppNavigator.change(
                      context,
                      (pages) => [
                        ...pages,
                        AppPages.product.page(
                            arguments: {'productId': productId.toString()}),
                      ],
                    ),
                  );
                },
                childCount: 10,
              ),
            ),
          ],
        ),
      );
}
