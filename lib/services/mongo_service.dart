// services/mongo_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class MongoService {
  // Configuration
  static const String baseUrl =
      'http://localhost:5000'; // Update with your actual API URL
  static const Duration timeoutDuration = Duration(seconds: 30);

  /// Check if the API is healthy and MongoDB is connected
  static Future<bool> isHealthy() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/health'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['status'] == 'healthy' && data['database'] == 'connected';
      }
      return false;
    } catch (e) {
      print('Health check failed: $e');
      return false;
    }
  }

  /// Check if MongoDB has data
  static Future<bool> hasData() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/stats'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['total_products'] > 0;
      }
      return false;
    } catch (e) {
      print('Error checking if data exists: $e');
      return false;
    }
  }

  /// Get database statistics
  static Future<Map<String, dynamic>?> getStats() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/stats'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      print('Error getting stats: $e');
      return null;
    }
  }

  /// Clear all data from MongoDB
  static Future<bool> clearAllData() async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/data/clear'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(timeoutDuration);

      return response.statusCode == 200;
    } catch (e) {
      print('Error clearing data: $e');
      return false;
    }
  }

  /// Run compliance check for a specific product
  static Future<bool> runComplianceCheck(String productId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/compliance/run/$productId'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(timeoutDuration);

      return response.statusCode == 200;
    } catch (e) {
      print('Error running compliance check: $e');
      return false;
    }
  }
}
