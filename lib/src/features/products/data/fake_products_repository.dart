import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  Future<List<Product>> fetchProductsList() async {
    await Future.delayed(const Duration(seconds: 3));

    return Future.value(_product);
  }

  Stream<List<Product>> watchProductsList() async* {
    await Future.delayed(const Duration(seconds: 3));
    yield _product;
  }

  Stream<Product> watchProduct(String id) {
    return watchProductsList()
        .map((products) => products.firstWhere((product) => product.id == id));
  }
}

final fakeRepositoryProvider =
    Provider.autoDispose<FakeProductsRepository>((ref) {
  return FakeProductsRepository.instance;
});

final productListStreamProvider =
    StreamProvider.autoDispose<List<Product>>((ref) {
  final fakeProductsRepository = ref.watch(fakeRepositoryProvider);
  return fakeProductsRepository.watchProductsList();
});

final productListFutureProvider =
    FutureProvider.autoDispose<List<Product>>((ref) {
  final fakeProductsRepository = ref.watch(fakeRepositoryProvider);
  return fakeProductsRepository.fetchProductsList();
});

final productProvider =
    StreamProvider.autoDispose.family<Product?, String>((ref, id) {
  final fakeProductsRepository = ref.watch(fakeRepositoryProvider);
  return fakeProductsRepository.watchProduct(id);
});
