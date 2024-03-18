import 'dart:async';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter/material.dart';
import 'package:random_products_flutter_app/Screens/Search/search.actions.dart';
import 'package:random_products_flutter_app/Widgets/organisms/index.dart';
import 'package:random_products_flutter_app/app_colors.dart';
import 'package:random_products_flutter_app/utils/custom_sliver_appbar_delegate.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

Widget _buildSearchField(
  BuildContext context,
  void Function(String) onChanged,
) {
  FocusNode focusNode = FocusNode();

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 1,
          blurRadius: 1,
          offset: const Offset(0, 1), // changes position of shadow
        ),
      ],
    ),
    child: TextField(
      focusNode: focusNode,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Search',
        filled: true,
        fillColor: AppColors.greyWhiteColor,
        prefixIcon: Icon(
          Icons.search,
          color: Theme.of(context).iconTheme.color,
        ),
        border: InputBorder.none,
        isDense: true,
      ),
    ),
  );
}

class _SearchState extends State<Search> {
  FocusNode focusNode = FocusNode();
  Timer? _debounce;

  List products = [];

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future _onSearchChanged(String query) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final results = await searchProducts(query: query);
      setState(() {
        products.add(results["data"]);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: SliverAppBarDelegate(
                minHeight: kToolbarHeight,
                maxHeight: kToolbarHeight,
                child: Container(
                  color: Colors.white,
                  child: _buildSearchField(context, _onSearchChanged),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                child: Text("Search Results"),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  print("producsts::::::::::::::::::");
                  print(products);
                  final product = products[index];
                  return const ProductCard(
                    id: "asdads",
                    name: "Title ",
                    price: 123,
                    imageUrl: "",
                  );
                },
                childCount: products.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
