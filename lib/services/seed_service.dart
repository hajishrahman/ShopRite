import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class SeedService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> seedProducts() async {
    final collection = _firestore.collection('products');
    final existing = await collection.limit(1).get();
    if (existing.docs.isNotEmpty) return;

    final products = [
      ProductModel(id: '', name: 'Apple iPhone 15', description: 'Latest iPhone with A16 chip, 48MP camera, and Dynamic Island.', price: 79999, originalPrice: 89999, category: 'Electronics', imageUrl: 'https://images.unsplash.com/photo-1695048133142-1a20484d2569?w=400', rating: 4.8, reviewCount: 245, stock: 15, isFeatured: true),
      ProductModel(id: '', name: 'Samsung Galaxy S24', description: 'Flagship Android phone with AI features and 200MP camera.', price: 74999, originalPrice: 84999, category: 'Electronics', imageUrl: 'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=400', rating: 4.7, reviewCount: 189, stock: 20, isFeatured: true),
      ProductModel(id: '', name: 'Sony WH-1000XM5', description: 'Industry leading noise cancelling wireless headphones.', price: 24999, originalPrice: 29999, category: 'Electronics', imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400', rating: 4.9, reviewCount: 312, stock: 30, isFeatured: true),
      ProductModel(id: '', name: 'Nike Air Max 270', description: 'Comfortable everyday sneakers with Max Air cushioning.', price: 8999, originalPrice: 11999, category: 'Fashion', imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400', rating: 4.5, reviewCount: 156, stock: 45, isFeatured: false),
      ProductModel(id: '', name: 'Levi\'s 511 Slim Jeans', description: 'Classic slim fit jeans in stretch denim.', price: 3499, originalPrice: 4999, category: 'Fashion', imageUrl: 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=400', rating: 4.3, reviewCount: 98, stock: 60, isFeatured: false),
      ProductModel(id: '', name: 'Instant Pot Duo 7-in-1', description: 'Electric pressure cooker, slow cooker, rice cooker and more.', price: 6999, originalPrice: 8999, category: 'Home', imageUrl: 'https://images.unsplash.com/photo-1585515320310-259814833e62?w=400', rating: 4.6, reviewCount: 423, stock: 25, isFeatured: true),
      ProductModel(id: '', name: 'IKEA KALLAX Shelf', description: 'Versatile shelf unit perfect for storage and display.', price: 4999, originalPrice: null, category: 'Home', imageUrl: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=400', rating: 4.4, reviewCount: 201, stock: 18, isFeatured: false),
      ProductModel(id: '', name: 'The Alchemist', description: 'Paulo Coelho\'s masterpiece about following your dreams.', price: 299, originalPrice: 499, category: 'Books', imageUrl: 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=400', rating: 4.7, reviewCount: 892, stock: 100, isFeatured: false),
      ProductModel(id: '', name: 'Atomic Habits', description: 'James Clear\'s guide to building good habits and breaking bad ones.', price: 399, originalPrice: 599, category: 'Books', imageUrl: 'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=400', rating: 4.8, reviewCount: 1203, stock: 85, isFeatured: true),
      ProductModel(id: '', name: 'Yoga Mat Premium', description: 'Non-slip 6mm thick yoga mat with carrying strap.', price: 1299, originalPrice: 1999, category: 'Sports', imageUrl: 'https://images.unsplash.com/photo-1601925228008-4ef9de9e9d7a?w=400', rating: 4.5, reviewCount: 167, stock: 40, isFeatured: false),
      ProductModel(id: '', name: 'Whey Protein Gold Standard', description: '100% whey protein powder, 24g protein per serving.', price: 3999, originalPrice: 4999, category: 'Sports', imageUrl: 'https://images.unsplash.com/photo-1593095948071-474c5cc2989d?w=400', rating: 4.6, reviewCount: 334, stock: 55, isFeatured: false),
      ProductModel(id: '', name: 'MacBook Air M2', description: 'Supercharged by M2 chip, incredibly thin and light.', price: 114999, originalPrice: 119999, category: 'Electronics', imageUrl: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=400', rating: 4.9, reviewCount: 567, stock: 10, isFeatured: true),
    ];

    final batch = _firestore.batch();
    for (final product in products) {
      final doc = collection.doc();
      batch.set(doc, product.toMap());
    }
    await batch.commit();
  }
}
