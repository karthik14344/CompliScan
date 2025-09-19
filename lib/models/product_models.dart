// models/product_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String title;
  final String imageUrl;
  final String mrp;
  final String netQuantity;
  final String countryOfOrigin;
  final String manufacturer;
  final String mfgDate;
  final int complianceScore;
  final List<String> violations;
  final String ocrText;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Product({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.mrp,
    required this.netQuantity,
    required this.countryOfOrigin,
    required this.manufacturer,
    required this.mfgDate,
    required this.complianceScore,
    required this.violations,
    required this.ocrText,
    this.status = 'completed',
    this.createdAt,
    this.updatedAt,
  });

  bool get isCompliant => violations.isEmpty && complianceScore >= 80;
  String get complianceStatus => isCompliant ? 'Compliant' : 'Non-Compliant';

  // Factory constructor to create Product from Firestore data
  factory Product.fromFirestore(Map<String, dynamic> data, String documentId) {
    final ocrData = data['ocr_data'] as Map<String, dynamic>? ?? {};
    final complianceData = data['compliance'] as Map<String, dynamic>? ?? {};

    return Product(
      id: documentId,
      title: data['product_title'] as String? ?? 'Unknown Product',
      imageUrl: data['image_url'] as String? ?? '',
      mrp: ocrData['mrp'] as String? ?? '',
      netQuantity: ocrData['net_quantity'] as String? ?? '',
      countryOfOrigin: ocrData['country_of_origin'] as String? ?? '',
      manufacturer: ocrData['name_of_the_manufacturer'] as String? ?? '',
      mfgDate: ocrData['date_of_manufacture'] as String? ?? '',
      complianceScore: complianceData['score'] as int? ?? 0,
      violations:
          List<String>.from(complianceData['violations'] as List? ?? []),
      ocrText: ocrData['raw_ocr_text'] as String? ?? '',
      status: data['status'] as String? ?? 'processing',
      createdAt: _parseDateTime(data['created_at']),
      updatedAt: _parseDateTime(data['updated_at']),
    );
  }

  static DateTime? _parseDateTime(dynamic dateTime) {
    if (dateTime == null) return null;
    if (dateTime is String) {
      return DateTime.tryParse(dateTime);
    }
    if (dateTime is Timestamp) {
      return dateTime.toDate();
    }
    return null;
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'product_title': title,
      'image_url': imageUrl,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'ocr_data': {
        'name_of_the_manufacturer': manufacturer,
        'country_of_origin': countryOfOrigin,
        'mrp': mrp,
        'net_quantity': netQuantity,
        'date_of_manufacture': mfgDate,
        'raw_ocr_text': ocrText,
      },
      'compliance': {
        'score': complianceScore,
        'status': complianceStatus.toLowerCase().replaceAll('-', '_'),
        'violations': violations,
        'analysis_timestamp': DateTime.now().toIso8601String(),
      },
    };
  }
}
