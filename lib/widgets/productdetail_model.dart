// widgets/product_detail_modal.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sih/models/product_models.dart';

class ProductDetailModal extends StatelessWidget {
  final Product product;

  const ProductDetailModal({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 800,
        height: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    product.title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: product.isCompliant
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: product.isCompliant ? Colors.green : Colors.red,
                    ),
                  ),
                  child: Text(
                    product.status.toUpperCase(),
                    style: TextStyle(
                      color: product.isCompliant ? Colors.green : Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),

            const Divider(),

            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left side - Image and OCR
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Product Image',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: product.imageUrl.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: product.imageUrl,
                                    fit: BoxFit.contain,
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.image_not_supported,
                                            size: 60, color: Colors.grey),
                                  )
                                : const Icon(Icons.image,
                                    size: 60, color: Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text('OCR Extracted Text',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: SingleChildScrollView(
                              child: Text(
                                product.rawOcrText.isNotEmpty
                                    ? product.rawOcrText
                                    : 'No OCR text available',
                                style: const TextStyle(
                                    fontSize: 12, fontFamily: 'monospace'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 24),

                  // Right side - Details
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Compliance Score
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: product.isCompliant
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: product.isCompliant
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      product.isCompliant
                                          ? Icons.check_circle
                                          : Icons.error,
                                      color: product.isCompliant
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        product.complianceScore != null
                                            ? '${product.complianceStatus.toUpperCase()} (${product.complianceScore}%)'
                                            : '${product.complianceStatus.toUpperCase()} (Score: null)',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (product.reasoning != null &&
                                    product.reasoning!.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    product.reasoning!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Product Information
                          _buildSectionHeader('Product Information'),
                          const SizedBox(height: 12),
                          _buildFieldRow('Product ID:', product.id),
                          _buildFieldRow(
                              'Product Name:', product.commonProductName),
                          _buildFieldRow(
                              'Created:', _formatDate(product.createdAt)),
                          _buildFieldRow(
                              'Last Updated:', _formatDate(product.updatedAt)),

                          const SizedBox(height: 20),

                          // Extracted Fields
                          _buildSectionHeader('Extracted Fields'),
                          const SizedBox(height: 12),
                          _buildFieldRow('MRP:', product.mrp ?? ''),
                          _buildFieldRow(
                              'Unit Sale Price:', product.unitSalePrice ?? ''),
                          _buildFieldRow('Net Quantity:', product.netQuantity),
                          _buildFieldRow('Country of Origin:',
                              product.countryOfOrigin ?? ''),
                          _buildFieldRow('Manufacturer:', product.manufacturer),
                          _buildFieldRow('Manufacturing Date:',
                              product.dateOfManufacture ?? ''),
                          _buildFieldRow(
                              'Best Before:', product.bestBefore ?? ''),

                          const SizedBox(height: 20),

                          // Manufacturer Details
                          if (product.manufacturerAddress.isNotEmpty) ...[
                            _buildSectionHeader('Manufacturer Details'),
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: Colors.blue.withOpacity(0.2)),
                              ),
                              child: Text(
                                product.manufacturerAddress,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],

                          // Violations
                          _buildSectionHeader('Compliance Violations'),
                          const SizedBox(height: 12),
                          if (product.violations.isEmpty)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    color: Colors.green.withOpacity(0.3)),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.check_circle,
                                      color: Colors.green, size: 16),
                                  SizedBox(width: 8),
                                  Text(
                                    'No violations detected',
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            )
                          else
                            ...product.violations.asMap().entries.map((entry) {
                              final index = entry.key;
                              final violation = entry.value;
                              return Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(
                                    bottom:
                                        index < product.violations.length - 1
                                            ? 8
                                            : 0),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                      color: Colors.red.withOpacity(0.3)),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.warning,
                                        color: Colors.red, size: 16),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        violation,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),

                          // Analysis Timestamp
                          if (product.analysisTimestamp != null) ...[
                            const SizedBox(height: 20),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Last analyzed: ${_formatDate(product.analysisTimestamp!)}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildFieldRow(String label, String value) {
    final isEmpty = value.isEmpty;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              isEmpty ? 'Not detected' : value,
              style: TextStyle(
                color: isEmpty ? Colors.red : Colors.black,
                fontStyle: isEmpty ? FontStyle.italic : FontStyle.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
