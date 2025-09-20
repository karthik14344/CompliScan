// services/compliance_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sih/models/product_models.dart';

class ComplianceService {
  // Update this URL to match your Flask API endpoint
  static const String baseUrl = 'http://localhost:5000'; // or your deployed URL
  static const String apiUrl = '$baseUrl/api/data';

  /// Fetches products from MongoDB via Flask API
  static Future<List<Product>> fetchProductsFromMongoDB() async {
    try {
      print('Fetching products from: $apiUrl');

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      print('Response status: ${response.statusCode}');
      print('Response headers: ${response.headers}');

      if (response.statusCode == 200) {
        final String responseBody = response.body;
        print('Response body length: ${responseBody.length}');

        // Parse the JSON response
        final List<dynamic> jsonList = json.decode(responseBody);
        print('Found ${jsonList.length} products');

        // Convert to Product objects
        final List<Product> products = jsonList
            .map((json) {
              try {
                return Product.fromJson(json as Map<String, dynamic>);
              } catch (e) {
                print('Error parsing product: $e');
                print('JSON: $json');
                return null;
              }
            })
            .where((product) => product != null)
            .cast<Product>()
            .toList();

        print('Successfully parsed ${products.length} products');
        return products;
      } else {
        print('HTTP Error: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching products: $e');
      rethrow;
    }
  }

  /// Adds a new product to MongoDB via Flask API
  static Future<void> addProductToMongoDB(Product product) async {
    try {
      final response = await http
          .post(
            Uri.parse(apiUrl),
            headers: {
              'Content-Type': 'application/json',
            },
            body: json.encode(product.toJson()),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 201) {
        throw Exception('Failed to add product: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding product: $e');
      rethrow;
    }
  }

  /// Checks if MongoDB has data by attempting to fetch products
  static Future<bool> hasData() async {
    try {
      final products = await fetchProductsFromMongoDB();
      return products.isNotEmpty;
    } catch (e) {
      print('Error checking if data exists: $e');
      return false;
    }
  }

  /// Inserts sample data to MongoDB (if needed)
  static Future<void> insertSampleDataToMongoDB() async {
    try {
      final sampleProducts = getSampleProducts();
      for (final product in sampleProducts) {
        await addProductToMongoDB(product);
      }
      print('Sample data inserted successfully');
    } catch (e) {
      print('Error inserting sample data: $e');
      rethrow;
    }
  }

  /// Runs compliance check for a specific product
  static Future<void> runComplianceCheck(String productId) async {
    // This would typically call an AI/ML service to analyze the product
    // For now, we'll just simulate the compliance check
    print('Running compliance check for product: $productId');

    // In a real implementation, you would:
    // 1. Fetch the product data
    // 2. Send OCR text to compliance analysis service
    // 3. Update the product with compliance results
    // 4. Save back to MongoDB

    // Simulated delay
    await Future.delayed(const Duration(milliseconds: 500));
  }

  /// Clears all products from MongoDB
  static Future<void> clearAllProducts() async {
    // This would require implementing a DELETE endpoint in your Flask API
    // For now, we'll just log the action
    print('Clear all products requested');
    throw UnimplementedError(
        'Clear all products endpoint not implemented in Flask API');
  }

  /// Gets sample products for testing/fallback
  static List<Product> getSampleProducts() {
    return [
      Product(
        id: '68cdbe100ed917d90190028f',
        title: 'KitKat Coated Wafer',
        imageUrl:
            'https://encrypted-tbn0.gstatic.com/shopping?q=tbn:ANd9GcTvHYRgHqA04EWJDw4fUfe52yX841AiPanxq9po4GRFw7pXSd-nuEGrwGhVQMVOpe9K7IRNON7YO1XLIrygX6obvCgJ-TrS36Zl0I0c9Rvv',
        status: 'ocr_uploaded',
        createdAt: DateTime.parse('2025-09-20T02:03:18+05:30'),
        updatedAt: DateTime.parse('2025-09-19T20:33:20Z'),
        manufacturer: 'NESTLE INDIA LTD',
        manufacturerAddress:
            'Mkt by: NESTLE INDIA LTD, 100101, WORLD TRADE CENTRE, BARAKHAMBA LANE, NEW DELHI-110001. Mfg by: NESTLE INDIA LTD, Plot No. 241,2,3,4 Usgan, Goa-400406',
        countryOfOrigin: null,
        commonProductName: 'Coated Wafer',
        netQuantity: '38.5 g',
        mrp: null,
        unitSalePrice: null,
        dateOfManufacture: null,
        bestBefore: null,
        rawOcrText: '''418764600
зохих в элоү Эрэлэ, в элон
NET QUANTITY: 38.5 g
MRP
(incl. of all taxes) (Rs.
per gl
For MFD-USE BY-Lot No. see under the seal.
Brand Owner: Registered Trademark of Societe Des Produits Nest
S.A, Avenue 55, 1800 Vevey S
fssai
Lic. No.10012011000168
Coated Wafer
INGREDIENTS
Sugar Milk solids (16.2%), Fractionated vegetable fat, Hydrogenated vegetable
fats, Refined Wheat flour Maidal, Cocoa solids (4.8%). Emulsifier(Sale)
Yeast, Raising agent (500, Artificial (Vanilla) flavouring substance, lodised salt,
Flour treatment agent (516) and Nature-identical flavouring substance.
Allergen Note: Contains Wheat Milk Sesame and Soy.
May contain t
NUTRITIONAL INFORMATION
Nestle India Ltd. 80-13-480-47-AAACN07576-22
Information
Carboyd
LET'S TALK
NESTLE CONSUMER CARE,
PO.BAG2, NEW DELHI-110001
WECARE INNESTLE.COM
1800 1031947
KNOW YOUR PORTION
81901058 903164
Mkt by: NESTLE INDIA LTD, 100101, WORLD TRADE
CENTRE, BARAKHAMBA LANE, NEW DELHI-110001.
Mfg by: NESTLE INDIA LTD, Plot No. 241,2,3,4
Usgan, Goa-400406 Lic. No. 10012025000202
STORAGE ADVICE
STORE EIN A COOL, DRY & HYGIENIC PLACE
Humidity and Temperature May Cause Product To
Develop A Whitish Layer. This Does Not Affect Its Fitness For Consumption
Have a break, have a KitKat''',
        complianceScore:
            null, // Show as null when no score available from MongoDB
        complianceStatus: 'non-compliant', // Exact status from MongoDB
        violations: [
          'Missing Country of Origin',
          'Missing MRP',
          'Missing Unit Sale Price',
          'Missing Date of Manufacture',
          'Missing Best Before Date'
        ],
        reasoning:
            'The product information is non-compliant due to missing critical fields mandated by the Legal Metrology Act.',
        analysisTimestamp: DateTime.parse('2024-02-27T12:00:00Z'),
      ),
      Product(
        id: '68cddb8cf918f860e045de92',
        title: "Lay's India's Magic Masala Potato Chips",
        imageUrl:
            'https://rukminim2.flixcart.com/image/832/832/xif0q/chips/3/j/b/-original-imagkwahjha3grdj.jpeg?q=70&crop=false',
        status: 'OCR UPLOADED',
        createdAt: DateTime.parse('2025-09-20T04:10:43+05:30'),
        updatedAt: DateTime.parse('2025-09-20T04:31:33.621000'),
        manufacturer: 'PEPSICO INDIA HOLDINGS PVT. LTD.',
        manufacturerAddress:
            'P.O. BOX 27, DLF QUTAB ENCLAVE, PHASE-1, GURUGRAM-122002, HARYANA, INDIA.',
        countryOfOrigin: 'INDIA',
        commonProductName: 'Potato Chips',
        netQuantity: '20 g',
        mrp: null,
        unitSalePrice: null,
        dateOfManufacture: null,
        bestBefore: null,
        rawOcrText: '''WAH!
Work At Home pack
Lay's
India's Magic
Masala
SPECIAL
SOUTH
FLAVOUR
Potato Chips
Per Serve (20g
Energy
5%
of Adur's RDA
...''', // Truncated for brevity
        complianceScore: 60, // From MongoDB compliance_score field
        complianceStatus: 'non-compliant', // Exact status from MongoDB
        violations: [
          'Missing MRP',
          'Missing Date of Manufacture',
          'Missing Best Before Date'
        ],
        reasoning:
            'The product information has violations because the MRP, date of manufacture, and best before date are missing. These are mandatory fields according to the provided rules.',
        analysisTimestamp: DateTime.parse('2025-09-19T23:05:44.529051Z'),
      ),
    ];
  }
}

/// Network utility class for handling API responses
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? error;
  final int? statusCode;

  ApiResponse({
    required this.success,
    this.data,
    this.error,
    this.statusCode,
  });

  factory ApiResponse.success(T data) {
    return ApiResponse(success: true, data: data);
  }

  factory ApiResponse.error(String error, [int? statusCode]) {
    return ApiResponse(success: false, error: error, statusCode: statusCode);
  }
}
