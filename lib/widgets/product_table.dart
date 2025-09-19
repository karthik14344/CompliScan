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
            child: Text(
              'Products (${products.length})',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Scrollable Table Content
          Expanded(
            child: Scrollbar(
              thumbVisibility: true,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: DataTable(
                    columnSpacing: 20,
                    headingRowColor: WidgetStateColor.resolveWith(
                      (states) => Colors.grey.shade100,
                    ),
                    columns: const [
                      DataColumn(
                        label: Text('Product',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('MRP',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('Net Quantity',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('Country',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('Score',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('Status',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('Violations',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                    rows: products.map((product) {
                      return DataRow(
                        onSelectChanged: (_) => onProductTap(product),
                        cells: [
                          DataCell(
                            SizedBox(
                              width: 200,
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Icon(Icons.image,
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
                                              fontWeight: FontWeight.w500),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          'ID: ${product.id}',
                                          style: const TextStyle(
                                              fontSize: 11, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              product.mrp.isEmpty ? 'Missing' : product.mrp,
                              style: TextStyle(
                                color: product.mrp.isEmpty
                                    ? Colors.red
                                    : Colors.black,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              product.netQuantity.isEmpty
                                  ? 'Missing'
                                  : product.netQuantity,
                              style: TextStyle(
                                color: product.netQuantity.isEmpty
                                    ? Colors.red
                                    : Colors.black,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              product.countryOfOrigin.isEmpty
                                  ? 'Missing'
                                  : product.countryOfOrigin,
                              style: TextStyle(
                                color: product.countryOfOrigin.isEmpty
                                    ? Colors.red
                                    : Colors.black,
                              ),
                            ),
                          ),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: product.complianceScore >= 80
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${product.complianceScore}%',
                                style: TextStyle(
                                  color: product.complianceScore >= 80
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
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
                                product.complianceStatus,
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
                              child: Text(
                                product.violations.isEmpty
                                    ? 'None'
                                    : product.violations.join(', '),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: product.violations.isEmpty
                                      ? Colors.green
                                      : Colors.red,
                                  fontSize: 12,
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
}
