import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ProductModel>> getAllProducts() async {
    final snapshot = await _firestore.collection('products').get();
    return snapshot.docs
        .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<List<ProductModel>> getFeaturedProducts() async {
    final snapshot = await _firestore
        .collection('products')
        .where('isFeatured', isEqualTo: true)
        .get();
    return snapshot.docs
        .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<List<ProductModel>> getProductsByCategory(String category) async {
    final snapshot = await _firestore
        .collection('products')
        .where('category', isEqualTo: category)
        .get();
    return snapshot.docs
        .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<List<ProductModel>> searchProducts(String query) async {
    final all = await getAllProducts();
    final q = query.toLowerCase();
    return all
        .where((p) =>
            p.name.toLowerCase().contains(q) ||
            p.category.toLowerCase().contains(q) ||
            p.description.toLowerCase().contains(q))
        .toList();
  }

  List<ProductModel> filterProducts(
    List<ProductModel> products, {
    String? category,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    bool? onSaleOnly,
  }) {
    return products.where((p) {
      if (category != null && category != 'All' && p.category != category) return false;
      if (minPrice != null && p.price < minPrice) return false;
      if (maxPrice != null && p.price > maxPrice) return false;
      if (minRating != null && p.rating < minRating) return false;
      if (onSaleOnly == true && !p.isOnSale) return false;
      return true;
    }).toList();
  }
}
