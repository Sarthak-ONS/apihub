import 'package:random_products_flutter_app/Infrastructure/HttpMethods/requesting_methods.dart';

Future searchProducts({
  int page = 1,
  int limit = 20,
  required String query,
}) async {
  final url = "/public/randomproducts?page=$page&limit=$limit&query=$query";
  final products = await ApiService.request(
    method: "GET",
    url: url,
  );

  return products["data"];
}
