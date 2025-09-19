import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sih/models/product_models.dart';

class StatsOverview extends StatelessWidget {
  final List<Product> products;

  const StatsOverview({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final compliantCount = products.where((p) => p.isCompliant).length;
    final nonCompliantCount = products.length - compliantCount;
    final avgScore = products.isEmpty
        ? 0
        : products.map((p) => p.complianceScore).reduce((a, b) => a + b) /
            products.length;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Products',
            products.length.toString(),
            Icons.inventory,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Compliant',
            compliantCount.toString(),
            Icons.check_circle,
            Colors.green,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Non-Compliant',
            nonCompliantCount.toString(),
            Icons.error,
            Colors.red,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Avg. Score',
            '${avgScore.toStringAsFixed(1)}%',
            Icons.analytics,
            Colors.orange,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Compliance Distribution',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 100,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            value: compliantCount.toDouble(),
                            color: Colors.green,
                            title: '$compliantCount',
                            titleStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          PieChartSectionData(
                            value: nonCompliantCount.toDouble(),
                            color: Colors.red,
                            title: '$nonCompliantCount',
                            titleStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                        sectionsSpace: 2,
                        centerSpaceRadius: 25,
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
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(title,
                    style: const TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
