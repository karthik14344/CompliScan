import 'package:flutter/material.dart';
import 'package:sih/models/product_models.dart';

class ProductTable extends StatelessWidget {
  final List<Product> products;
  final Function(Product) onProductTap;

  const ProductTable({
    Key? key,
    required this.products,
    required this.onProductTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Table Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.inventory_2, color: Colors.grey[600], size: 20),
                const SizedBox(width: 8),
                Text(
                  'Products (${products.length})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (products.isNotEmpty) ...[
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Click row to view details',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Scrollable Table Content
          Expanded(
            child: products.isEmpty
                ? _buildEmptyState()
                : Scrollbar(
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        child: DataTable(
                          columnSpacing: 20,
                          headingRowColor: WidgetStateColor.resolveWith(
                            (states) => Colors.grey.shade100,
                          ),
                          dataRowMinHeight: 60,
                          dataRowMaxHeight: 80,
                          columns: const [
                            DataColumn(
                              label: Text('Product',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            DataColumn(
                              label: Text('MRP',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            DataColumn(
                              label: Text('Net Quantity',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            DataColumn(
                              label: Text('Country',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            DataColumn(
                              label: Text('Manufacturer',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            DataColumn(
                              label: Text('Score',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            DataColumn(
                              label: Text('Status',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            DataColumn(
                              label: Text('Violations',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                          rows: products.map((product) {
                            return DataRow(
                              onSelectChanged: (_) => onProductTap(product),
                              selected: false,
                              cells: [
                                DataCell(
                                  SizedBox(
                                    width: 200,
                                    child: Row(
                                      children: [
                                        // Product Image or Icon
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            border: Border.all(
                                                color: Colors.grey[300]!),
                                          ),
                                          child: product.imageUrl.isNotEmpty
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  child: Image.network(
                                                    product.imageUrl,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context,
                                                            error,
                                                            stackTrace) =>
                                                        const Icon(
                                                            Icons
                                                                .image_not_supported,
                                                            color: Colors.grey,
                                                            size: 20),
                                                    loadingBuilder: (context,
                                                        child,
                                                        loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) return child;
                                                      return const Center(
                                                        child: SizedBox(
                                                          width: 16,
                                                          height: 16,
                                                          child:
                                                              CircularProgressIndicator(
                                                                  strokeWidth:
                                                                      2),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                )
                                              : const Icon(Icons.inventory_2,
                                                  color: Colors.grey, size: 20),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                product.title,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                product.commonProductName
                                                        .isNotEmpty
                                                    ? product.commonProductName
                                                    : 'ID: ${product.id.length > 10 ? product.id.substring(0, 10) + "..." : product.id}',
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.grey[600]),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                DataCell(
                                  _buildFieldCell(
                                    product.mrp ?? '',
                                    isEmpty: (product.mrp?.isEmpty ?? true),
                                  ),
                                ),
                                DataCell(
                                  _buildFieldCell(
                                    product.netQuantity,
                                    isEmpty: product.netQuantity.isEmpty,
                                  ),
                                ),
                                DataCell(
                                  _buildFieldCell(
                                    product.countryOfOrigin ?? '',
                                    isEmpty:
                                        (product.countryOfOrigin?.isEmpty ??
                                            true),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: 120,
                                    child: Text(
                                      product.manufacturer.isNotEmpty
                                          ? product.manufacturer
                                          : 'Not specified',
                                      style: TextStyle(
                                        color: product.manufacturer.isEmpty
                                            ? Colors.grey
                                            : Colors.black,
                                        fontSize: 12,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _getScoreColor(
                                              product.complianceScore ?? 0)
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: _getScoreColor(
                                                product.complianceScore ?? 0)
                                            .withOpacity(0.3),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          _getScoreIcon(
                                              product.complianceScore ?? 0),
                                          color: _getScoreColor(
                                              product.complianceScore ?? 0),
                                          size: 12,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${product.complianceScore}%',
                                          style: TextStyle(
                                            color: _getScoreColor(
                                                product.complianceScore ?? 0),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: product.isCompliant
                                          ? Colors.green
                                          : Colors.red,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      product.complianceStatus.toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: 150,
                                    child: product.violations.isEmpty
                                        ? Row(
                                            children: [
                                              Icon(Icons.check_circle,
                                                  color: Colors.green[600],
                                                  size: 14),
                                              const SizedBox(width: 4),
                                              const Text(
                                                'None',
                                                style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          )
                                        : Tooltip(
                                            message:
                                                product.violations.join('\n• '),
                                            child: Row(
                                              children: [
                                                Icon(Icons.warning,
                                                    color: Colors.red[600],
                                                    size: 14),
                                                const SizedBox(width: 4),
                                                Expanded(
                                                  child: Text(
                                                    '${product.violations.length} violation${product.violations.length > 1 ? 's' : ''}',
                                                    style: const TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No products found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters or refresh the data',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldCell(String value, {required bool isEmpty}) {
    return Row(
      children: [
        if (isEmpty) ...[
          Icon(Icons.error_outline, color: Colors.red[400], size: 14),
          const SizedBox(width: 4),
        ],
        Text(
          isEmpty ? 'Missing' : value,
          style: TextStyle(
            color: isEmpty ? Colors.red : Colors.black,
            fontSize: 12,
            fontWeight: isEmpty ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  IconData _getScoreIcon(int score) {
    if (score >= 80) return Icons.check_circle;
    if (score >= 60) return Icons.warning;
    return Icons.error;
  }
}
