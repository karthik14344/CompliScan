// services/firebase_service.dart - Firebase Service for CompliScan
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sih/models/product_models.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _productsCollection = 'products';

  // Stream to get all products
  static Stream<List<Product>> getProducts() {
    return _firestore
        .collection(_productsCollection)
        .where('status', isEqualTo: 'completed')
        .orderBy('updated_at', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Product.fromFirestore(data, doc.id);
      }).toList();
    });
  }

  // Get single product by ID
  static Future<Product?> getProduct(String id) async {
    try {
      final doc =
          await _firestore.collection(_productsCollection).doc(id).get();
      if (doc.exists && doc.data() != null) {
        return Product.fromFirestore(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      print('Error fetching product $id: $e');
      return null;
    }
  }

  // Get products by compliance status
  static Stream<List<Product>> getProductsByComplianceStatus(bool isCompliant) {
    final status = isCompliant ? 'compliant' : 'non_compliant';
    return _firestore
        .collection(_productsCollection)
        .where('status', isEqualTo: 'completed')
        .where('compliance.status', isEqualTo: status)
        .orderBy('updated_at', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Product.fromFirestore(data, doc.id);
      }).toList();
    });
  }

  // Create initial product record (for backend use)
  static Future<String> createProduct({
    required String imageUrl,
    required String productTitle,
  }) async {
    try {
      final docRef = _firestore.collection(_productsCollection).doc();
      final now = DateTime.now().toIso8601String();

      await docRef.set({
        'id': docRef.id,
        'image_url': imageUrl,
        'product_title': productTitle,
        'status': 'processing',
        'created_at': now,
        'updated_at': now,
      });

      return docRef.id;
    } catch (e) {
      print('Error creating product: $e');
      throw Exception('Failed to create product');
    }
  }

  // Update product with OCR data (for backend use)
  static Future<void> updateWithOCRData(
      String productId, Map<String, dynamic> ocrData) async {
    try {
      await _firestore.collection(_productsCollection).doc(productId).update({
        'ocr_data': ocrData,
        'status': 'ocr_completed',
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error updating OCR data: $e');
      throw Exception('Failed to update OCR data');
    }
  }

  // Update product with compliance data (for backend use)
  static Future<void> updateWithComplianceData(
      String productId, int score, List<String> violations) async {
    try {
      await _firestore.collection(_productsCollection).doc(productId).update({
        'compliance': {
          'score': score,
          'status': score >= 80 ? 'compliant' : 'non_compliant',
          'violations': violations,
          'analysis_timestamp': DateTime.now().toIso8601String(),
        },
        'status': 'completed',
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error updating compliance data: $e');
      throw Exception('Failed to update compliance data');
    }
  }

  // Get processing statistics
  static Future<Map<String, int>> getProcessingStats() async {
    try {
      final snapshot = await _firestore.collection(_productsCollection).get();
      final stats = <String, int>{
        'total': 0,
        'processing': 0,
        'completed': 0,
        'compliant': 0,
        'non_compliant': 0,
      };

      for (final doc in snapshot.docs) {
        final data = doc.data();
        stats['total'] = (stats['total'] ?? 0) + 1;

        final status = data['status'] as String?;
        if (status != null) {
          stats[status] = (stats[status] ?? 0) + 1;
        }

        if (status == 'completed') {
          final complianceStatus = data['compliance']?['status'] as String?;
          if (complianceStatus != null) {
            stats[complianceStatus] = (stats[complianceStatus] ?? 0) + 1;
          }
        }
      }

      return stats;
    } catch (e) {
      print('Error fetching stats: $e');
      return {
        'total': 0,
        'processing': 0,
        'completed': 0,
        'compliant': 0,
        'non_compliant': 0
      };
    }
  }
}
