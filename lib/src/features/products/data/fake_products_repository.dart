import '../../../constants/test_products.dart';
import '../domain/product.dart';

class FakeProductsRepository {
  FakeProductsRepository._();

  final _product = kTestProducts;

  static FakeProductsRepository instance = FakeProductsRepository._();

  List<Product> getProductsList() {
    return _product;
  }

  Product? getProduct(String id) {
    return _product.firstWhere((product) => product.id == id);
  }

  Future<List<Product>> fetchProductsList() {
    return Future.value(_product);
  }

  Stream<List<Product>> watchProductsList() {
    return Stream.value(_product);
  }

  Stream<Product> watchProduct(String id) {
    return watchProductsList()
        .map((products) => products.firstWhere((product) => product.id == id));
  }
}
