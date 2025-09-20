// models/product_models.dart
class Product {
  final String id;
  final String title;
  final String imageUrl;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  // OCR Data fields
  final String manufacturer;
  final String manufacturerAddress;
  final String? countryOfOrigin;
  final String commonProductName;
  final String netQuantity;
  final String? mrp;
  final String? unitSalePrice;
  final String? dateOfManufacture;
  final String? bestBefore;
  final String rawOcrText;

  // Compliance fields
  final int? complianceScore; // Made nullable
  final String complianceStatus;
  final List<String> violations;
  final String? reasoning;
  final DateTime? analysisTimestamp;

  Product({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.manufacturer,
    required this.manufacturerAddress,
    this.countryOfOrigin,
    required this.commonProductName,
    required this.netQuantity,
    this.mrp,
    this.unitSalePrice,
    this.dateOfManufacture,
    this.bestBefore,
    required this.rawOcrText,
    this.complianceScore, // Made nullable
    required this.complianceStatus,
    required this.violations,
    this.reasoning,
    this.analysisTimestamp,
  });

  // Convenience getters - only use MongoDB data, no internal calculations
  bool get isCompliant => complianceStatus.toLowerCase() == 'compliant';
  String get ocrText => rawOcrText;
  String get mfgDate => dateOfManufacture ?? '';

  factory Product.fromJson(Map<String, dynamic> json) {
    // Handle the nested structure from MongoDB
    final ocrData = json['ocr_data'] as Map<String, dynamic>? ?? {};
    final compliance = json['compliance'] as Map<String, dynamic>? ?? {};
    final complianceResult =
        json['compliance_result'] as Map<String, dynamic>? ?? {};

    // Use compliance_result if available, otherwise fall back to compliance
    final complianceData =
        complianceResult['compliance'] as Map<String, dynamic>? ?? compliance;

    // Parse violations - return null if no violations exist
    List<String>? violationsList;
    final violations = complianceData['violations'] as List<dynamic>? ?? [];
    if (violations.isNotEmpty) {
      violationsList = [];
      for (var violation in violations) {
        if (violation is Map<String, dynamic>) {
          violationsList
              .add(violation['issue']?.toString() ?? 'Unknown violation');
        } else if (violation is String) {
          violationsList.add(violation);
        }
      }
    }

    // Parse compliance score from MongoDB (could be string with % or int, or null)
    int? parseComplianceScore(dynamic scoreData) {
      if (scoreData == null) return null;

      if (scoreData is int) {
        return scoreData;
      } else if (scoreData is String) {
        // Remove % sign if present and parse
        String cleanScore = scoreData.replaceAll('%', '').trim();
        try {
          return int.parse(cleanScore);
        } catch (e) {
          return null;
        }
      }
      return null;
    }

    // Parse dates safely
    DateTime? parseDate(dynamic dateStr) {
      if (dateStr == null) return null;
      try {
        return DateTime.parse(dateStr.toString());
      } catch (e) {
        return null;
      }
    }

    return Product(
      id: json['_id']['\$oid'] ?? json['_id']?.toString() ?? '',
      title: json['product_title']?.toString() ?? 'Unknown Product',
      imageUrl: json['image_url']?.toString() ?? '',
      status: json['status']?.toString() ?? 'unknown',
      createdAt: parseDate(json['created_at']) ?? DateTime.now(),
      updatedAt: parseDate(json['updated_at']) ?? DateTime.now(),

      // OCR Data
      manufacturer: ocrData['manufacturer']?.toString() ?? '',
      manufacturerAddress: ocrData['manufacturer_address']?.toString() ?? '',
      countryOfOrigin: ocrData['country_of_origin']?.toString(),
      commonProductName: ocrData['common_product_name']?.toString() ?? '',
      netQuantity: ocrData['net_quantity']?.toString() ?? '',
      mrp: ocrData['mrp']?.toString(),
      unitSalePrice: ocrData['unit_sale_price']?.toString(),
      dateOfManufacture: ocrData['date_of_manufacture']?.toString(),
      bestBefore: ocrData['best_before']?.toString(),
      rawOcrText: ocrData['raw_ocr_text']?.toString() ?? '',

      // Compliance Data - Only use data from MongoDB, return null if not present
      complianceScore: parseComplianceScore(
          complianceData['compliance_score'] ?? complianceData['score']),
      complianceStatus: complianceData['compliance_status']?.toString() ??
          complianceData['status']?.toString() ??
          'unknown',
      violations: violationsList ??
          [], // Return empty list instead of null for easier handling
      reasoning: complianceData['reasoning']?.toString() ??
          json['reasoning']?.toString(),
      analysisTimestamp: parseDate(complianceData['analysis_timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': {'\$oid': id},
      'product_title': title,
      'image_url': imageUrl,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'ocr_data': {
        'manufacturer': manufacturer,
        'manufacturer_address': manufacturerAddress,
        'country_of_origin': countryOfOrigin,
        'common_product_name': commonProductName,
        'net_quantity': netQuantity,
        'mrp': mrp,
        'unit_sale_price': unitSalePrice,
        'date_of_manufacture': dateOfManufacture,
        'best_before': bestBefore,
        'raw_ocr_text': rawOcrText,
      },
      'compliance': {
        'score': complianceScore,
        'status': complianceStatus,
        'violations': violations.map((v) => {'issue': v}).toList(),
        'reasoning': reasoning,
        'analysis_timestamp': analysisTimestamp?.toIso8601String(),
      },
    };
  }
}

// Helper class for violation details
class ComplianceViolation {
  final String field;
  final String issue;
  final String ruleReference;
  final String reason;

  ComplianceViolation({
    required this.field,
    required this.issue,
    required this.ruleReference,
    required this.reason,
  });

  factory ComplianceViolation.fromJson(Map<String, dynamic> json) {
    return ComplianceViolation(
      field: json['field']?.toString() ?? '',
      issue: json['issue']?.toString() ?? '',
      ruleReference: json['rule_reference']?.toString() ?? '',
      reason: json['reason']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'field': field,
      'issue': issue,
      'rule_reference': ruleReference,
      'reason': reason,
    };
  }

  @override
  String toString() => issue;
}
